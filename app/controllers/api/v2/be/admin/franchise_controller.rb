# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class FranchiseController < Api::V2::Be::Admin::BaseController
          before_action :set_franchise, except: [:new]

          def new
            @franchise = ::Franchise.new(franchise_params)
            if @franchise.save
              success({ data: @franchise })
            else
              unprocessable({ errors: @franchise.errors })
            end
          end

          def update
            if @franchise.update(franchise_params)
              success({ data: @franchise })
            else
              unprocessable({ errors: @franchise.errors })
            end
          end

          def remove
            @franchise.archive!
            success({ data: @franchise })
          end

          private

          def franchise_params
            params.require(:franchise).permit(:title, :description, franchise_address_attributes: [:location_id, :region_id, :street])
          end

          def set_franchise
            @franchise = ::Franchise.find_by(id: params[:id])
            notfound({ resource: "franchise" }) if @franchise.nil?
          end
        end
      end
    end
  end
end
