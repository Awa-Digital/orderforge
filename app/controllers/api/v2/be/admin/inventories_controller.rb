# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class InventoriesController < Api::V2::Be::Admin::BaseController
          before_action :set_inventory, except: [:new, :search]

          def search
            search_for_model(Inventory, params[:page], params[:per_page])
          end

          def new
            @inventory = Inventory.new(inventory_params)

            if @inventory.save
              success({ data: @inventory })
            else
              unprocessable({ errors: @inventory.errors })
            end
          end

          def update
            if @inventory.update(inventory_params)
              success({ data: @inventory })
            else
              unprocessable({ errors: @inventory.errors })
            end
          end

          def remove
            @inventory.archive!
            success({ data: @inventory })
          end

          private

          def inventory_params
            params.require(:inventory).permit(:code, :name, :description, :state, :expires)
          end

          def set_inventory
            @inventory = Inventory.find_by(id: params[:id])
            notfound({ resource: "inventory" }) if @inventory.nil?
          end
        end
      end
    end
  end
end
