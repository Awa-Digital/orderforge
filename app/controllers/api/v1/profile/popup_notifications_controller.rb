class Api::V1::Profile::PopupNotificationsController < Api::V1::Profile::BaseController
  before_action :authenticate_user

  # GET /api/v1/profile/popup-notifications/unseen
  def unseen
    notifications = PopupNotification.where.not(
      id: UserPopupNotificationView.where(user_id: @mobile_user.id).select(:popup_notification_id)
    )

    success({ message: 'Unseen popup notifications fetched', data: notifications })
  end

  # POST /api/v1/profile/popup-notifications/views
  # params: { popup_notification_id: Integer }
  def create_view
    popup_notification = PopupNotification.find_by(id: params[:popup_notification_id])

    return notfound({ message: 'Popup notification not found' }) unless popup_notification

    view = UserPopupNotificationView.find_or_initialize_by(
      user: @mobile_user,
      popup_notification:
    )

    if view.save
      success({ message: 'Popup notification marked as viewed', data: view })
    else
      unprocessable({ message: 'Could not record popup notification view', data: view.errors })
    end
  end
end
