# frozen_string_literal: true

class Order
  module StateMachine
    extend ActiveSupport::Concern

    included do
      include AASM

      aasm column: :status do
        state :initiated, initial: true
        state :paid
        state :awaiting_processing
        state :processing
        state :awaiting_packaging
        state :packaged
        state :delivering
        state :completed
        state :cancelled

        event :mark_paid do
          transitions from: :initiated, to: :paid, guard: :payment_completed?

          after do
            create_order_snapshot!
            dispatch_order_paid_notification
          end
        end

        event :start_processing do
          transitions from: %i[paid awaiting_processing], to: :processing
        end

        event :await_packaging do
          transitions from: :processing, to: :awaiting_packaging
        end

        event :package do
          transitions from: %i[awaiting_packaging processing], to: :packaged
        end

        event :start_delivery do
          transitions from: :packaged, to: :delivering
        end

        event :complete do
          transitions from: :delivering, to: :completed

          after do
            Wallets::ReleasePendingForOrderService.call(order: self)
          end
        end

        event :cancel do
          transitions from: %i[initiated paid awaiting_processing], to: :cancelled
        end
      end
    end

    def payment_completed?
      payment&.status == 'completed' || payment&.paid == true
    end

    private

    def dispatch_order_paid_notification
      Notifications::Dispatch.call(
        kind: :order_paid,
        notifiable: self,
        context: { order: self, user: user }
      )
    rescue Notifications::Definitions::Registry::UnknownKindError
      nil
    end
  end
end
