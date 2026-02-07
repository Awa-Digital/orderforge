class Api::V1::OrdersController < Api::V1::BaseController
  skip_before_action :authenticate_user,
                     only: %i[cart create_guest_cart add_multi add get_paid_cart update update_cart update_address update_franchise remove_ingredient remove attach_recipient address_areas address_regions franchises
                              regions_areas]
  before_action :authenticate_guest,
                only: %i[cart create_guest_cart add_multi get_paid_cart add update update_cart remove_ingredient update_address update_franchise franchises remove attach_recipient]
  before_action :set_product, only: %i[add add_for_signed_in_user update remove]
  before_action :set_cart, except: [:address_areas, :get_paid_cart, :franchises]

  def cart
    @cart_render = @cart
    @message = 'Cart Fetched!'
    Rails.logger.info("Cart from /cart: #{@cart.inspect}")
    render 'cart'
  end

  def update_franchise
    @cart.update_attribute :franchise_id, params[:franchise_id]
    clear_cart_address
    @cart.recalculate
    @cart_render = Order.find(@cart.id)
    @message = 'Cart Fetched!'
    render 'cart'
  end

  def get_paid_cart
    @cart = Order.find_by(reference: params[:reference], paid: true)
    return notfound(message: "Cart not found") unless @cart

    success({ data: @cart, message: "Cart Fetched!" })
  end

  def create_guest_cart
    items = params[:items]
    items.each do |item|
      @product = Product.find_by(id: item[:product_id])

      add_to_cart(item[:product_id], item[:quantity], @cart, item[:removables]) if @product.present?
    end
    @cart_render = Order.find(@cart.id)
    @message = 'Items have been added to cart'
    render 'cart'
  end

  def add_multi
    items = params[:items]
    items.each do |item|
      @product = Product.find_by(id: item[:product_id])

      add_to_cart(item[:product_id], item[:quantity], @cart, item[:removables]) if @product.present?
    end
    @cart_render = Order.find(@cart.id)
    @message = 'Items have been added to cart'
    Rails.logger.info("Cart from /add_multi: #{@cart.inspect}")
    render 'cart'
  end

  def add
    @item = add_to_cart(@product.id, params[:quantity].to_i, @cart, params[:removables]) if @product.present?
    @cart_render = Order.find(@cart.id)
    @message = 'Items have been added to cart'
    render 'cart'
  end

  def add_for_signed_in_user
    @item = add_to_cart(@product.id, params[:quantity].to_i, @cart, params[:removables]) if @product.present?
    @cart_render = Order.find(@cart.id)
    @message = 'Items have been added to cart'
    render 'cart'
  end

  def update
    @item = @cart.items.find_by(product_id: @product.id)
    if @item.present?
      @item.update(quantity: params[:quantity].to_i)
      @cart.recalculate

      @cart_render = Order.find(@cart.id)
      @message = 'item has been updated on cart'
      render 'cart'
    else
      notfound({ message: 'No product found with this id' })
    end
  end

  # PATCH/PUT /cart — update cart (bulk items and/or recipient, franchise). Allowed for guests.
  def update_cart
    if params[:items].present?
      params[:items].each do |item_params|
        product = Product.find_by(id: item_params[:product_id])
        next unless product

        item = @cart.items.find_or_create_by(product_id: product.id)
        item.quantity = item_params[:quantity].to_i
        item.save!
        add_removables(item, item_params[:removables]) if item_params[:removables].present?
      end
    end

    if params[:recipient].present?
      recipient = {}
      recipient[:recipient_name] = params[:recipient][:name] if params[:recipient][:name].present?
      recipient[:recipient_phone] = params[:recipient][:phone] if params[:recipient][:phone].present?
      recipient[:recipient_email] = params[:recipient][:email].strip if params[:recipient][:email].present? && !@mobile_user.present?
      @cart.update!(recipient) if recipient.any?
    end

    @cart.update_attribute(:franchise_id, params[:franchise_id]) if params[:franchise_id].present?

    @cart.recalculate
    @cart_render = Order.find(@cart.id)
    @message = 'Cart has been updated'
    render 'cart'
  end

  def add_to_cart(product_id, quantity, cart, removables)
    @item = cart.items.find_or_create_by(product_id:)
    @item.quantity = quantity.to_i
    begin
      @item.save!
      add_removables(@item, removables) if removables.present?
    rescue StandardError => e
      puts e.message
      puts 'PRODUCT DID NOT SAVE'
    end
  end

  def remove_ingredient
    if Removable.find_or_create_by!(order_item_id: params[:order_item_id], ingredient_id: params[:ingredient_id])
      success({ message: 'Item included in the removed list', data: @removable })
    else
      unprocessable({ message: 'Item included in the removed list' })
    end
  end

  def add_removables(item, removables)
    return if removables.empty?

    removables.map do |rem|
      @ingredient = Product.find_by(id: item.product_id).ingredients.where(id: rem['ingredient_id']).present?
      Removable.create!(order_item_id: item.id, ingredient_id: rem['ingredient_id']) if @ingredient
    end
  end

  def update_address
    @cart = Order.find_by(id: params[:order_id])
    address = guest_address_obj(params)

    @cart.order_address.update!(
      JSON.parse(address.to_json)
    )

    @franchise = FranchiseAddress.find_by(region_id: @cart.order_address.delivery_area.region_id)
    @cart.update!(franchise_id: @franchise.id)
    @cart.recalculate

    success({ message: 'Address has been updated successfully', data: @cart.order_address })
  end

  # to avoid mobile app breaking
  def guest_address_obj(params)
    {
      house_number: params['house_number'],
      street: params['street'],
      state: params['state'],
      delivery_area_id: params['delivery_area_id'],
      country: params['country']
    }
  end

  def remove
    @item = @cart.items.find_by(product_id: @product.id)
    if @item.present?
      @item.destroy
      @cart.update_totals
      success({ message: 'item has been removed from cart', data: @item })
    else
      notfound({ message: 'No product found with this id' })
    end
  end

  def attach_address
    @address = @mobile_user.addresses.find_by(id: params[:address_id])
    if @address.present?
      @mobile_user.cart.order_address.update!(JSON.parse(@address.to_json).except('id', 'as_string'))
      @mobile_user.cart.order_address.update!(delivery_area_id: @address.delivery_area_id)

      @franchise = FranchiseAddress.find_by(region_id: @address.delivery_area.region_id)
      @mobile_user.cart.update!(franchise_id: @franchise.id)
      @mobile_user.cart.recalculate

      success({ message: 'Address has been assigned successfully', data: @address })
    else
      notfound({ message: 'No address found with this id for this user' })
    end
  end

  def attach_recipient
    recipient = {
      recipient_name: params[:recipient]['name'],
      recipient_phone: params[:recipient]['phone']
    }
    recipient[:recipient_email] = params[:recipient]['email'].strip unless @mobile_user.present?
    @cart.update(
      recipient
    )
    success({ message: 'Recipient has been updated', data: {
              recipient: {
                name: @cart.recipient_name,
                phone: @cart.recipient_phone,
                email: @cart.recipient_email
              }
            } })
  end

  def address_areas
    region = Region.find(1)
    areas = region.delivery_areas.all.reject { |x| x.day_rate.nil? }.sort_by(&:name)
    success({ message: 'Areas Fetched', data: areas })
  end

  def address_regions
    areas = Region.all
    success({ message: 'Regions Fetched', data: areas })
  end

  def franchises
    success({ message: 'Franchises', data: Franchise.all })
  end

  def regions_areas
    region = Region.find(params[:region_id])
    areas = region.delivery_areas.all.reject { |x| x.price.nil? }.sort_by(&:name)
    success({ message: 'Areas Fetched', data: areas })
  end

  private

  def clear_cart_address
    return unless @cart.order_address.present?

    @cart.order_address.update!(
      delivery_area_id: nil,
      region_id: nil,
      location_id: nil,
      house_number: nil,
      street: nil,
      city: nil,
      state: nil,
      country: nil
    )
  end

  def set_product
    @product = Product.find_by(id: params[:product_id])
    if @product.present?
      @product
    else
      notfound({ message: 'No product found with this id on cart' })
    end
  end

  def set_cart
    @cart = if @mobile_user.present?
              puts @mobile_user.cart.id
              @mobile_user.cart
            else
              find_or_create_guest_cart
            end

    # add influencer to cart if present
    affiliate = Influencer.find_by(slug: params[:affiliate_slug])
    @cart.update(influencer_id: affiliate.id) if affiliate
  end

  def find_or_create_guest_cart
    # First, try to find by order_id if provided (preferred method)
    if params[:order_id].present?
      @order = Order.find_by(id: params[:order_id])
      return create_or_find_order(@order) if @order
    end

    # Use guest token hash to find the cart
    guest_token_hash = extract_guest_token_hash
    return create_new_guest_cart(guest_token_hash) unless guest_token_hash

    # Find existing cart by guest_token_hash
    existing_cart = Order.where(guest_token_hash: guest_token_hash, status: 'initiated')
                         .where('created_at > ?', 24.hours.ago)
                         .order(created_at: :desc)
                         .first

    return existing_cart if existing_cart

    # Create new cart with guest token hash
    create_new_guest_cart(guest_token_hash)
  end

  def extract_guest_token_hash
    authorization_header = request.headers[:authorization]
    return nil unless authorization_header

    # Extract token from "Bearer <token>" format
    parts = authorization_header.split
    return nil unless parts.length >= 2

    token = parts[1]
    return nil unless token.present?

    # Hash the token to create a unique identifier for this guest
    Digest::SHA256.hexdigest(token)
  end

  def create_new_guest_cart(guest_token_hash = nil)
    Order.create(
      status: 'initiated',
      franchise_id: Franchise.first.id,
      guest_token_hash: guest_token_hash
    )
  end

  def create_or_find_order(order)
    if order.present?
      if order.status == 'initiated'
        # Update guest_token_hash if it's missing and we have a token
        guest_token_hash = extract_guest_token_hash
        order.update(guest_token_hash: guest_token_hash) if guest_token_hash && order.guest_token_hash.nil?
        order
      else
        create_new_guest_cart(extract_guest_token_hash)
      end
    else
      create_new_guest_cart(extract_guest_token_hash)
    end
  end
end
