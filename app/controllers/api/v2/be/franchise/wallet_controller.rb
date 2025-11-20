# frozen_string_literal: true

module Api
  module V2
    module Be
      module Franchise
        class WalletController < BaseController
          before_action :set_franchise

          def show
            wallet = @franchise.wallet || @franchise.create_wallet!
            render json: {
              available_balance: wallet.available_balance,
              pending_balance: wallet.pending_balance,
              transactions: wallet.wallet_transactions.order(created_at: :desc).limit(50)
            }
          end

          def withdraw
            wallet = @franchise.wallet || @franchise.create_wallet!
            bank_detail = @franchise.bank_details.find(params[:bank_detail_id])
            amount_cents = (params[:amount].to_d * 100).round

            Wallets::WithdrawToBankService.call(
              wallet: wallet,
              amount_cents: amount_cents,
              bank_detail: bank_detail
            )
            render json: { message: 'Withdrawal recorded' }, status: :ok
          rescue Wallets::WithdrawToBankService::InsufficientBalance
            render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
          end

          private

          def set_franchise
            @franchise = ::Franchise.find(params[:franchise_id])
          end
        end
      end
    end
  end
end
