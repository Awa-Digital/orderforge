# frozen_string_literal: true

module Api
  module V2
    module Be
      module Franchise
        class BaseController < Api::V2::Be::BaseController
          skip_before_action :authenticate_user
          # before_action :authenticate_admin

          # include AdminAuthentication

          def search_for_model(model, page, per_page)
            @results = model.all.ransack(params[:q]).result(distinct: true).page(page).per(per_page)

            results = {
              results: @results, total_results: @results.count,
              results_per_page: @results.limit_value,
              total_pages: @results.total_pages,
              next_page: @results.next_page, last_page: @results.last_page?
            }
            success({ message: 'results found', data: results })
          end
        end
      end
    end
  end
end
