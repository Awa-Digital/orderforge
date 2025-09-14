class OtpMailer < ApplicationMailer
  before_action :noreply_email

  layout 'mailer'

  def otp
    @account = params[:account]
    @otp = @account.otp
    @preheader = "Your Jazzy Burger verification code"

    mail(to: @account.email, subject: 'Your Jazzy Burger verification code', delivery_method_options: @delivery_options)
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e)) if defined?(Sentry)
    Sentry.capture_message(e) if defined?(Sentry)
  end
end
