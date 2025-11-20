# frozen_string_literal: true

module Api
  module V2
    module Be
      module Franchise
        class AnalyticsController < BaseController
          before_action :set_franchise

          def summary
            render json: FranchiseAnalytics::Summary.call(franchise: @franchise, days: days_param)
          end

          def timeseries
            render json: FranchiseAnalytics::Timeseries.call(franchise: @franchise, days: days_param)
          end

          def top_products
            render json: FranchiseAnalytics::TopProducts.call(franchise: @franchise, days: days_param)
          end

          def record_visit
            FranchisePageVisit.create!(
              franchise: @franchise,
              visitor_uuid: params.require(:visitor_uuid),
              user_id: @mobile_user&.id,
              path: params[:path]
            )
            head :created
          end

          private

          def set_franchise
            @franchise = ::Franchise.find(params[:franchise_id])
          end

          def days_param
            params.fetch(:days, 7).to_i.clamp(1, 90)
          end
        end
      end
    end
  end
end
