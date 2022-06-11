# Set & Update Notification
class Api::V1::Profile::NotificationController < Api::V1::Profile::BaseController
  def settings
    @settings = @mobile_user.notification_setting
    success({ message: 'Settings fetched', data: @settings })
  end

  def update_settings
    # byebug
    settings = @mobile_user.notification_setting
    begin
      settings.update(notification_params)
    rescue StandardError => e
      unprocessable({ message: e.message, data: settings.errors })
    else
      success({ message: 'Settings updated successfully', data: settings })
    end
  end

  private

  def notification_params
    params.require(:notification_setting).permit(:push_notifications, :app_updates, :promotions, :receipts, :newsletter)
  end
end
