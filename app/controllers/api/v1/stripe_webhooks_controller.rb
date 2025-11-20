# frozen_string_literal: true

class Api::V1::StripeWebhooksController < Api::V1::BaseController
  skip_before_action :authenticate_user

  def create
    handle_event(params[:type])
    head :ok
  end

  private

  def handle_event(event_type)
    case event_type
    when 'payment_intent.succeeded'
      reference = params.dig(:data, :object, :metadata, :payment_reference)
      payment = Payment.find_by(reference: reference)
      payment&.confirm_stripe!
    end
  end
end
