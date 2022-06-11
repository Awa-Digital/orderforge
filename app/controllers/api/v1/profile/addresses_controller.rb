# for User Addresses
class Api::V1::Profile::AddressesController < Api::V1::Profile::BaseController
  def index
    @addresses = @mobile_user.addresses
    success({ message: 'Addresses fetched', data: @addresses })
  end

  def new_address
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

  # Only allow a list of trusted parameters through.
  def address_params
    params.require(:address).permit(:street, :city, :state, :country)
  end
end
