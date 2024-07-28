class SendMarketingSmsJob
  include Sidekiq::Job

  def perform(recipient, text)
    TermiiSms.new.send_marketing_sms(recipient, text)
  end
end
