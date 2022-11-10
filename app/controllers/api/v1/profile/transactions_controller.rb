class Api::V1::Profile::TransactionsController < Api::V1::Profile::BaseController
  skip_before_action :authenticate_user, only: %i[show]
  before_action :authenticate_guest, only: %i[show]

  def index
    @transactions = @mobile_user.orders.where(paid: true)
    @message = 'transactions fetched successfully'
    render 'index'
  end

  def show
    @transaction = Order.find_by(reference: params[:order_reference])
    @message = 'transaction fetched successfully'
    render 'show'
  end
end
