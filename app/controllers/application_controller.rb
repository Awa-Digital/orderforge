# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user
  skip_before_action :authenticate_user, if: -> { request.path.start_with?('/admin') }

  include Responses
  include Authentication

end
