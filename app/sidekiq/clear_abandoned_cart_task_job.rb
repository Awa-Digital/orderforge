class ClearAbandonedCartTaskJob
  include Sidekiq::Job

  def perform(*_args)
    scope = Order.where(status: "initiated").where("updated_at < ?", 2.weeks.ago)

    scope.find_in_batches(batch_size: 1000) do |batch|
      batch.each(&:destroy)
    end
  rescue StandardError => e
    Rails.logger.error "Error deleting abandoned carts: #{e.message}"
  end
end
