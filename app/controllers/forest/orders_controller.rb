class Forest::OrdersController < ForestLiana::SmartActionsController
  def print_receipt
    order_id = params[:data][:attributes][:ids].first
    order = Order.find(order_id)
    pdf = order.generate_pdf_receipt
    send_data File.open(pdf).read, filename: "#{order.reference}.pdf", type: 'application/pdf', disposition: 'attachment'
  end
end
