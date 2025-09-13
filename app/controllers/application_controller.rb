# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user

  skip_before_action :authenticate_user, if: -> { request.path.start_with?('/admin') }
  skip_before_action :authenticate_user, if: -> { ENV['ADMIN_APP'] == 'true' }
  before_action :whodunit_user, if: -> { ENV['ADMIN_APP'] == 'true' }

  before_action :redirect_to_admin_path_if_needed

  include Responses
  include Authentication

  # Whodunit configuration - tells whodunit how to get the current user
  def whodunit_user
    # @current_user = current_admin_user
    Whodunit::Current.user = current_admin_user
  end

  private

  def redirect_to_admin_path_if_needed
    return unless request.subdomain == 'admin' && !request.path.start_with?('/admin')

    redirect_to "/admin#{request.fullpath}", allow_other_host: true
  end
end
