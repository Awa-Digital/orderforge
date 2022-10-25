# frozen_string_literal: true

require 'sendgrid-ruby'

module SendgridApi
  # Sending Emails
  class Email
    def initialize
      @sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    end

    def verify_email(user, url)
      mail = SendGrid::Mail.new
      mail.template_id = 'd-3c17f4bf236a4fb7b8eb036660027630'
      mail.from = SendGrid::Email.new(email: 'no-reply@mystem.ng', name: 'Lynk Email Verification')
      subject = 'Important: Verify Your Email on Lynk'
      mail.subject = subject
      personalization = make_personalization(user, url, subject)
      mail.add_personalization(personalization)
      response = @sg.client.mail._('send').post(request_body: mail.to_json)
      print response
    end

    def make_personalization(user, url, subject)
      personalization = SendGrid::Personalization.new
      personalization.add_to(SendGrid::Email.new(email: user.email, name: user.name))
      personalization.add_dynamic_template_data({
                                                  'subject' => subject,
                                                  'first_name' => user.first_name,
                                                  'email' => user.email,
                                                  'confirm_url' => url
                                                })
    end

    def sendmail(template_id, sender_email, sender_name, subject)
      mail = SendGrid::Mail.new
      mail.template_id = template_id
      mail.from = SendGrid::Email.new(email: sender_email, name: sender_name)
      # subject = transaction.subject
      mail.subject = subject
      mail
    end

    def init(reciever_email, subject_var, content, email_type)
      from = SendGrid::Email.new(email: 'uchenna@callphoneng.com')
      to = SendGrid::Email.new(email: reciever_email)
      subject = subject_var
      content = SendGrid::Content.new(type: email_type, value: content)
      SendGrid::Mail.new(from, subject, to, content)
    end
  end
end
