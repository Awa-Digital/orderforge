# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class InfluencersController < Api::V2::Be::Admin::BaseController
          before_action :set_influencer, except: [:new]

          def new
            @influencer = Influencer.new(influencer_params)
            if @influencer.save
              success({ data: @influencer })
            else
              unprocessable({ errors: @influencer.errors })
            end
          end

          def update
            if @influencer.update(influencer_params)
              success({ data: @influencer })
            else
              unprocessable({ errors: @influencer.errors })
            end
          end

          def remove
            @influencer.archive!
            success({ data: @influencer })
          end

          private

          def influencer_params
            params.require(:influencer).permit(:name, :instagram_handle, :twitter_handle, :email, :password, :password_digest)
          end

          def set_influencer
            @influencer = Influencer.find_by(id: params[:id])
            notfound({ resource: "influencer" }) if @influencer.nil?
          end
        end
      end
    end
  end
end
