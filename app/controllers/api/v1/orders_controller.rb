class Api::V1::OrdersController < Api::V1::BaseController
  skip_before_action :authenticate_user,
                     only: %i[cart create_guest_cart add get_paid_cart update update_address remove_ingredient remove attach_recipient address_areas address_regions regions_areas]
  before_action :authenticate_guest, only: %i[cart create_guest_cart get_paid_cart add update remove_ingredient update_address remove attach_recipient]
  before_action :set_product, only: %i[add add_for_signed_in_user update remove]
  before_action :set_cart, except: [:address_areas, :get_paid_cart]

  def cart
    @cart_render = @cart
    @message = 'Cart Fetched!'
    render 'cart'
  end

  def get_paid_cart
    @cart = Order.find_by(reference: params[:reference], paid: true)
    return notfound(message: "Cart not found") unless @cart
    success({data: @cart, message: "Cart Fetched!"})
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
    render 'cart'
  end

  def add
    puts "••••••• Cart •••••••"
    puts @cart.id
    puts "••••••• Cart •••••••"
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
      @cart.sum_total

      @cart_render = Order.find(@cart.id)
      @message = 'item has been updated on cart'
      render 'cart'
    else
      notfound({ message: 'No product found with this id' })
    end
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

  def regions_areas
    region = Region.find(params[:region_id])
    areas = region.delivery_areas.all.reject { |x| x.day_rate.nil? }.sort_by(&:name)
    success({ message: 'Areas Fetched', data: areas })
  end

  private

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
              puts "••••••• User Cart •••••••"
              puts @mobile_user.cart.id
              puts "••••••• User •••••••"
              @mobile_user.cart
            else
              @order = Order.find_by(id: params[:order_id])
              create_or_find_order(@order)
            end
  end

  def create_or_find_order(order)
    if order.present?
      if order.status == 'initiated'
        order
      else
        Order.create(status: 'initiated')
      end
    else
      Order.create(status: 'initiated')
    end
  end
end
