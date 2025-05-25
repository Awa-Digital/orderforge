class ReportTaskJob
  include Sidekiq::Job

  def perform(orders, requester_id)
    orders = Order.where(id: orders)
    report = Reports.new(orders, AdminUser.find(requester_id))
    report.process
  end
end
