class Api::V1::Profile::TransactionsController < Api::V1::Profile::BaseController
  def index
    @transactions = @mobile_user.orders.where(paid: true)
    @message = 'transactions fetched successfully'
    render 'index'
  end

  def show
    @transaction = @mobile_user.orders.find_by(reference: params[:order_reference])
    @message = "transaction fetched successfully"
    render 'show'
  end
end
