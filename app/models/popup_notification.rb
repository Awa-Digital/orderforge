class PopupNotification < ApplicationRecord
  mount_uploader :image, PopupNotificationUploader
  has_many :user_popup_notification_views, dependent: :destroy
  has_many :users, through: :user_popup_notification_views

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description id image updated_at url]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user_popup_notification_views users]
  end
end
