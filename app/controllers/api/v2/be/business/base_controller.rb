# frozen_string_literal: true

module Api
  module V2
    module Be
      module Business
        class BaseController < Api::V2::Be::BaseController
          skip_before_action :authenticate_user
          before_action :authenticate_admin

          include AdminAuthentication

        end
      end
    end
  end
end
