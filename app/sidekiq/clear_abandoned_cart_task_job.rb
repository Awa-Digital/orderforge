class ClearAbandonedCartTaskJob
  include Sidekiq::Job

  def perform(*args)
    Order.where(status: "initiated").where("updated_at < ?", 2.weeks.ago).destroy_all
  end
end
