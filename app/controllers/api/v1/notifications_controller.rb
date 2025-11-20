# frozen_string_literal: true

class Api::V1::NotificationsController < Api::V1::BaseController
  def index
    render json: @mobile_user.notifications.order(created_at: :desc).limit(50)
  end

  def mark_seen
    notification = @mobile_user.notifications.find(params[:id])
    notification.see
    render json: notification
  end
end
