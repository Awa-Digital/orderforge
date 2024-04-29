# frozen_string_literal: true

# for Backend Authorization
module Api
  module V2
    module Be
      module Admin
        class InfluencersController < Api::V2::Be::Admin::BaseController
          before_action :set_influencer, except: [:new, :search, :search_voucher]
          before_action :set_voucher, only: [:update_voucher, :remove_voucher]

          def search
            search_for_model(Influencer, params[:page], params[:per_page])
          end

          def search_voucher
            search_for_model(Voucher, params[:page], params[:per_page])
          end

          def new
            @influencer = Influencer.new(influencer_params)
            if @influencer.save
              success({ data: @influencer })
            else
              unprocessable({ errors: @influencer.errors })
            end
          end

          def new_voucher
            @voucher = @influencer.vouchers.new(voucher_params)
            if @voucher.save
              success({ data: @voucher })
            else
              unprocessable({ errors: @voucher.errors })
            end
          end

          def update
            if @influencer.update(influencer_params)
              success({ data: @influencer })
            else
              unprocessable({ errors: @influencer.errors })
            end
          end

          def update_voucher
            if @voucher.update(voucher_params)
              success({ data: @voucher })
            else
              unprocessable({ errors: @voucher.errors })
            end
          end

          def remove
            @influencer.archive!
            success({ data: @influencer })
          end

          def remove_voucher
            @voucher.archive!
            success({ data: @voucher })
          end

          private

          def influencer_params
            params.require(:influencer).permit(:name, :instagram_handle, :twitter_handle, :email, :password, :password_digest)
          end

          def voucher_params
            params.require(:voucher).permit(:title, :discount_code, :discount_rate, :expiration_date)
          end

          def set_influencer
            @influencer = Influencer.find_by(id: params[:id])
            notfound({ resource: "influencer" }) if @influencer.nil?
          end

          def set_voucher
            @voucher = @influencer.vouchers.find_by(id: params[:voucher_id])
            notfound({ resource: "voucher" }) if @voucher.nil?
          end
        end
      end
    end
  end
end
