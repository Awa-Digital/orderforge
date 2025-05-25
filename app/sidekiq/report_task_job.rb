class ReportTaskJob
  include Sidekiq::Job

  def perform(orders, requester_id, filters)
    orders = Order.where(id: orders)
    report = Reports.new(orders, AdminUser.find(requester_id), filters)
    report.process
  end
end
