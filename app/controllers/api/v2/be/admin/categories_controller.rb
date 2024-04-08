# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class CategoriesController < Api::V2::Be::Admin::BaseController
          before_action :set_category, except: [:new]

          def new
            @category = Category.new(category_params)
            if @category.save
              success({ data: @category })
            else
              unprocessable({ errors: @category.errors })
            end
          end

          def remove
            @category.archive!
            success({ data: @category })
          end

          private

          def category_params
            params.require(:category).permit(:title, :description, :image)
          end

          def set_category
            @category = Category.find_by(id: params[:id])
            notfound({ resource: "category" }) if @category.nil?
          end
        end
      end
    end
  end
end
