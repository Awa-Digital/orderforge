class ReportMailer < ApplicationMailer
  before_action :noreply_email

  def report_email
    @report = params[:report]
    @requester = @report.admin_user
    @preheader = 'Your report is ready'

    mail(to: @requester.email, subject: "#{@requester.first_name} - Your report is ready", delivery_method_options: @delivery_options)
  rescue Net::SMTPAuthenticationError => e
    Sentry.capture_exception(Net::SMTPAuthenticationError.new(e))
    Sentry.capture_message(e)
  end
end
