class InfluencerMailer < ApplicationMailer
  before_action :noreply_email
  layout 'receipt_template'

  def welcome
    @user = Influencer.find(params[:id])
    @preheader = "Next Steps to get your affiliate account approved -"

    mail(
      to: @user.email,
      from: "Jazzy's Burger <#{@delivery_options[:user_name]}>",
      subject: "Next Steps to get your affiliate account approved",
      delivery_method_options: @delivery_options
    )
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end

  def approval
    @user = Influencer.find(params[:id])
    @preheader = "Your account has been approved -"

    mail(
      to: @user.email,
      from: "Jazzy's Burger <#{@delivery_options[:user_name]}>",
      subject: "Affiliate Account Approved",
      delivery_method_options: @delivery_options
    )
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end

  def purchase_notification
    @order = Order.find(params[:order_id])
    @user = @order.influencer
    return unless @user.present?

    rate = (@user.commission_rate.presence || 20) / 100.0
    @commission_amount = (@order.total * rate).round(2)
    @first_name = @user.name.to_s.split(" ").first.presence || @user.name
    @preheader = "#{@first_name}, You earned ₦#{ActiveSupport::NumberHelper.number_to_delimited(@commission_amount)}."

    mail(
      to: @user.email,
      from: "Jazzy's Burger <#{@delivery_options[:user_name]}>",
      subject: "#{@first_name}, You earned ₦#{ActiveSupport::NumberHelper.number_to_delimited(@commission_amount)}.",
      delivery_method_options: @delivery_options
    )
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end
end
