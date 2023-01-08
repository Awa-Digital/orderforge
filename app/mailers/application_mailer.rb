class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@jazzysburger.com'
  layout 'mailer'

  EMAIL = {
    receipts: {
      user_name: ENV['RECEIPTS_EMAIL'],
      password: ENV['RECEIPTS_PASSWORD']
    },
    notify: {
      user_name: ENV['NOTIFY_EMAIL'],
      password: ENV['NOTIFY_PASSWORD']
    },
    web: {
      user_name: ENV['WEB_EMAIL'],
      password: ENV['WEB_PASSWORD']
    },
    noreply: {
      user_name: ENV['NOREPLY_EMAIL'],
      password: ENV['NOREPLY_PASSWORD']
    }
  }

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
