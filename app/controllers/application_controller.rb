# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user
  skip_before_action :authenticate_user, if: -> { request.path.start_with?('/admin') }
  before_action :redirect_to_admin_path_if_needed

  include Responses
  include Authentication

  private

  def redirect_to_admin_path_if_needed
    return unless request.subdomain == 'admin' && !request.path.start_with?('/admin')

    redirect_to "/admin#{request.fullpath}", allow_other_host: true
  end
end
