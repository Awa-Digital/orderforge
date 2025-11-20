# frozen_string_literal: true

module PaymentStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm column: :status do
      state :pending, initial: true
      state :processing
      state :completed
      state :failed
      state :refunded

      event :process do
        transitions from: :pending, to: :processing
      end

      event :complete do
        transitions from: %i[pending processing], to: :completed

        after do
          sync_paid_flag!
          record_payment_time
          notify_payment_success
          trigger_order_payment_completion
          credit_franchise_wallet
        end
      end

      event :fail do
        transitions from: %i[pending processing], to: :failed
      end

      event :refund do
        transitions from: :completed, to: :refunded, guard: :refundable?

        after do
          sync_paid_flag!
        end
      end

      event :retry do
        transitions from: :failed, to: :pending
      end
    end

    scope :completed_payments, -> { where(status: 'completed') }
  end

  def complete_payment!
    complete! if may_complete?
  end

  private

  def refundable?
    (status == 'completed' || paid) && paid_at.present? && paid_at > 90.days.ago
  end

  def sync_paid_flag!
    update_column(:paid, status == 'completed')
  end

  def record_payment_time
    update_column(:paid_at, Time.current) if paid_at.blank?
  end

  def notify_payment_success
    SlackApi.send_order_message(order) if order.present?
  rescue StandardError => e
    Rails.logger.warn("Slack notification failed: #{e.message}")
  end

  def trigger_order_payment_completion
    order.generate_completion_notification if order.present? && !order.paid?
  end

  def credit_franchise_wallet
    Wallets::CreditFromOrderService.call(payment: self)
  end
end
