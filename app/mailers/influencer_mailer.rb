class InfluencerMailer < ApplicationMailer
  before_action :noreply_email
  layout 'receipt_template'

  def welcome
    @user = Influencer.find(params[:id])
    @preheader = "Next Steps to get your affiliate account approved -"

    mail(to: @user.email, from: "Jazzy's Burger <#{@delivery_options[:user_name]}>", subject: "Jazzy's Burger Affiliate Approval", delivery_method_options: @delivery_options)
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end

  def approval
    @user = Influencer.find(params[:id])
    @preheader = "Your account has been approved -"

    mail(to: @user.email, from: "Jazzy's Burger <#{@delivery_options[:user_name]}>", subject: "Jazzy's Burger:Affiliate Account Approved", delivery_method_options: @delivery_options)
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end
end
