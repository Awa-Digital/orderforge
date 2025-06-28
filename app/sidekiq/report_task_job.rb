class ReportTaskJob
  include Sidekiq::Job

  def perform(params)
    params = JSON.parse(params)

    order_ids = params['order_ids']
    requester_id = params['user_id']
    filters = params['filters']

    orders = Order.where(id: order_ids).includes(:payment).order('payments.paid_at asc')
    report = Reports.new(orders, AdminUser.find(requester_id), filters)
    report.process
  end
end
