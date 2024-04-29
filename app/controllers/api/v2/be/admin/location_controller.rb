# frozen_string_literal: true

# Managing Regions, Countries, Cities, etc...
module Api
  module V2
    module Be
      module Admin
        class LocationController < Api::V2::Be::Admin::BaseController
          before_action :set_country, except: [:new_country, :search_country, :search_states, :search_cities]
          before_action :set_state, except: [:new_country, :remove_country, :new_region, :search_country, :search_states, :search_cities]

          def new_country
            @country = Location.new(country_params)

            if @country.save
              success({ data: @country })
            else
              unprocessable({ errors: @country.errors })
            end
          end

          def remove_country
            @country.archive!
            success({ data: @country })
          end

          def search_country
            search_for_model(Location, params[:page], params[:per_page])
          end

          def new_region
            @state = @country.regions.new(state_params)

            if @state.save
              success({ data: @state })
            else
              unprocessable({ errors: @state.errors })
            end
          end

          def search_states
            search_for_model(Region, params[:page], params[:per_page])
          end

          def remove_state
            @state.archive!
            success({ data: @state })
          end

          def new_city
            @city = @state.delivery_areas.new(city_params)

            if @city.save
              success({ data: @city })
            else
              unprocessable({ errors: @city.errors })
            end
          end

          def search_cities
            search_for_model(DeliveryArea, params[:page], params[:per_page])
          end

          def remove_city
            @city = DeliveryArea.find_by(id: params[:city_id])
            return notfound({ resource: "city" }) if @city.nil?

            @city.archive!
            success({ data: @city })
          end

          private

          def country_params
            params.require(:country).permit(:name)
          end

          def state_params
            params.require(:state).permit(:location_id, :name)
          end

          def city_params
            params.require(:city).permit(:name, :day_rate, :dusk_rate, :dawn_rate, :night_rate, :region_id)
          end

          def set_country
            @country = Location.find_by(id: params[:id])
            notfound({ resource: "country" }) if @country.nil?
          end

          def set_state
            @state = @country.regions.find_by(id: params[:state_id])
            notfound({ resource: "state" }) if @state.nil?
          end
        end
      end
    end
  end
end
