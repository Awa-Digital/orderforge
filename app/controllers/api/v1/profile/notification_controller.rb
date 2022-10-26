# Set & Update Notification
class Api::V1::Profile::NotificationController < Api::V1::Profile::BaseController
  def settings
    @settings = @mobile_user.notification_setting
    success({ message: 'Settings fetched', data: @settings })
  end

  def update_settings
    settings = @mobile_user.notification_setting
    begin
      settings.update(notification_params)
    rescue StandardError => e
      unprocessable({ message: e.message, data: settings.errors })
    else
      success({ message: 'Settings updated successfully', data: settings })
    end
  end

  def register_device
    device = Device.find_or_initialize_by(device_token: params[:device_token])
    device.user_id = @mobile_user.id
    device.device_name = params[:device_name]
    device.serial_number = params[:serial_number]
    if device.save
      success({ message: 'Device Registered', data: device })
    else
      @errors = @user.errors
      unprocessable({ message: 'Something went wrong', data: @errors })
    end
  end

  private

  def notification_params
    params.require(:notification_setting).permit(:push_notifications, :app_updates, :promotions, :receipts, :newsletter)
  end
end
