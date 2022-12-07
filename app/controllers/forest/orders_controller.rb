class Forest::OrdersController < ForestLiana::SmartActionsController
  def print_receipt
    order_id = params[:data][:attributes][:ids].first
    order = Order.find(order_id)
    pdf = order.generate_pdf_receipt
    send_data File.open(pdf).read, filename: "#{order.reference}.pdf", type: 'application/pdf', disposition: 'attachment'
  end

  def verify_payment
    order_ids = params[:data][:attributes][:ids]
    orders = Order.find(order_ids)
    orders.map(&:verify)
  end

  def mark_as_processing
    order_ids = params[:data][:attributes][:ids]
    orders = Order.find(order_ids)
    orders.map{|o| o.update(status: 'processing')}
  end

  def mark_as_delivering
    order_ids = params[:data][:attributes][:ids]
    orders = Order.find(order_ids)
    orders.map{|o| o.update(status: 'delivering')}
  end

  def mark_as_complete
    order_ids = params[:data][:attributes][:ids]
    orders = Order.find(order_ids)
    orders.map{|o| o.update(status: 'completed')}
  end
end
