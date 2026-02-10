class UserPopupNotificationView < ApplicationRecord
  belongs_to :user
  belongs_to :popup_notification
end

