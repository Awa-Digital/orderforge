# frozen_string_literal: true

module PaymentStripeProcess
  extend ActiveSupport::Concern

  def initiate_stripe!
    update!(provider: 'stripe', status: 'pending')
    intent = Stripe::Payment::Intent.create(
      amount: payment_total,
      currency: ENV.fetch('STRIPE_CURRENCY', 'ngn'),
      order_id: order_id,
      metadata: { payment_reference: reference }
    )
    update!(
      sc_payment_intent_id: intent.id,
      sc_payment_secret: intent.client_secret,
      gateway: 'stripe'
    )
    intent
  end

  def confirm_stripe!
    process! if may_process?
    complete_payment! if may_complete?
  end
end
