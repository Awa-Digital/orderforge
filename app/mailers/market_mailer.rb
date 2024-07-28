class MarketMailer < ApplicationMailer
  before_action :awadigital_email

  layout 'market'

  def elearn
    @user = params[:user]

    @preheader = "Join awasome tech bootcamp and learn front end development for free - "

    mail(to: @user.email, subject: 'Become a Developer - Learn for Free', delivery_method_options: @delivery_options)
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end
end
