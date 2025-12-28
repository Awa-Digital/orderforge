# for User Addresses
class Api::V1::Profile::AddressesController < Api::V1::Profile::BaseController
  skip_before_action :authenticate_user, only: [:new_address]
  before_action :authenticate_guest, only: [:new_address]
  before_action :handle_guest_address, only: [:new_address], if: -> { params[:order_id].present? && @mobile_user.nil? }

  def index
    @addresses = @mobile_user.addresses
    success({ message: 'Addresses fetched', data: @addresses })
  end

  def new_address
    # If order_id is provided and user is guest, handle guest address (already handled by before_action)
    return if @guest_address_handled

    # Otherwise, create address for authenticated user
    address = @mobile_user.addresses.new(address_params)
    begin
      address.save!
    rescue StandardError => e
      unprocessable({ message: e.message, data: address.errors })
    else
      success({ message: 'Address added successfully', data: address })
    end
  end

  def show
    @address = @mobile_user.addresses.find_by(id: params[:id])
    if @address.present?
      success({ message: 'Address fetched', data: @address })
    else
      notfound({ message: 'Addresss not found' })
    end
  end

  def remove
    @address = @mobile_user.addresses.find_by(id: params[:id])
    if @address.present?
      @address.destroy!
      success({ message: 'Address removed', data: @address })
    else
      notfound({ message: 'Addresss not found' })
    end
  end

  private

  def handle_guest_address
    @cart = Order.find_by(id: params[:order_id])
    unless @cart
      notfound({ message: 'Order not found' })
      return
    end

    # Verify this is a guest cart (no user_id) or belongs to the guest token
    guest_token_hash = extract_guest_token_hash
    if @cart.user_id.present?
      unauthorized({ message: 'This order belongs to a registered user' })
      return
    end

    # If guest_token_hash exists, verify it matches
    if @cart.guest_token_hash.present? && guest_token_hash.present? && !(@cart.guest_token_hash == guest_token_hash)
      unauthorized({ message: 'Order does not belong to this guest' })
      return
    end

    address_data = {
      house_number: params[:house_number] || params.dig(:address, :house_number),
      street: params[:street] || params.dig(:address, :street),
      state: params[:state] || params.dig(:address, :state),
      delivery_area_id: params[:delivery_area_id] || params.dig(:address, :delivery_area_id),
      country: params[:country] || params.dig(:address, :country)
    }

    @cart.order_address.update!(address_data)

    @franchise = FranchiseAddress.find_by(region_id: @cart.order_address.delivery_area.region_id)
    @cart.update!(franchise_id: @franchise.id) if @franchise
    @cart.recalculate

    @guest_address_handled = true
    success({ message: 'Address has been updated successfully', data: @cart.order_address })
  end

  def extract_guest_token_hash
    authorization_header = request.headers[:authorization]
    return nil unless authorization_header

    parts = authorization_header.split
    return nil unless parts.length >= 2

    token = parts[1]
    return nil unless token.present?

    Digest::SHA256.hexdigest(token)
  end

  # Only allow a list of trusted parameters through.
  def address_params
    params.require(:address).permit(:street, :state, :delivery_area_id, :country, :house_number)
  end
end
