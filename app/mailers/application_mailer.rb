class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@jazzysburger.com'
  layout 'mailer'

  EMAIL = {
    receipts: {
      user_name: ENV.fetch('RECEIPTS_EMAIL', nil),
      password: ENV.fetch('RECEIPTS_PASSWORD', nil)
    },
    notify: {
      user_name: ENV.fetch('NOTIFY_EMAIL', nil),
      password: ENV.fetch('NOTIFY_PASSWORD', nil)
    },
    web: {
      user_name: ENV.fetch('WEB_EMAIL', nil),
      password: ENV.fetch('WEB_PASSWORD', nil)
    },
    noreply: {
      user_name: ENV.fetch('NOREPLY_EMAIL', nil),
      password: ENV.fetch('NOREPLY_PASSWORD', nil)
    }
  }.freeze

  private

  def set_receipt_email
    @delivery_options = EMAIL[:receipts]
  end

  def notify_email
    @delivery_options = EMAIL[:notify]
  end

  def web_email
    @delivery_options = EMAIL[:web]
  end

  def noreply_email
    @delivery_options = EMAIL[:noreply]
  end
end
