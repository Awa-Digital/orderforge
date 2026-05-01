class ReportTaskJob
  include Sidekiq::Job

  def perform(params)
    params = JSON.parse(params)

    order_ids = params['order_ids']
    requester_id = params['user_id']
    filters = params['filters']

    # Rails.logger.info("ReportTaskJob: #{params}")

    orders = Order.where(id: order_ids).includes(:payment).order('payments.paid_at asc')
    # Rails.logger.info("ReportTaskJob: orders: #{orders.count}")
    report = Reports.new(orders, AdminUser.find(requester_id), filters)
    report.process
  rescue StandardError => e
    Rails.logger.error("ReportTaskJob: #{e.message}")
    Sentry.capture_exception(e)
  end
end
