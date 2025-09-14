class NotificationSetting < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :user

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at user_id id]
    super
  end
end
