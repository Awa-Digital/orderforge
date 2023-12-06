# frozen_string_literal: true

require 'sendgrid-ruby'

module SendgridApi
  # Sending Emails
  class Email
    include ActionView::Helpers::NumberHelper
    def initialize
      @sg = SendGrid::API.new(api_key: ENV.fetch('SENDGRID_API_KEY', nil))
      @mail = SendGrid::Mail.new
      set_senders
    end

    def verify_email(user)
      @mail.template_id = 'd-899ad334cbc542c7b85810afd9ee509d'
      @mail.from = SendGrid::Email.new(email: @noreply, name: @noreply_title)
      subject = "Important: Verify Your Email #{user.first_name}"
      @mail.subject = subject
      data = SendgridApi::EmailBuilder.verification_email_data(user)
      personalization = make_personalization(user, data)
      @mail.add_personalization(personalization)
      @sg.client.mail._('send').post(request_body: @mail.to_json)
    end

    def order_receipt_email(order)
      @mail.template_id = 'd-5c23e94785584498835113282036cbb2'
      @mail.from = SendGrid::Email.new(email: @noreply, name: @noreply_title)
      subject = "Your Order Receipt ##{order.reference}"
      @mail.subject = subject
      data = SendgridApi::EmailBuilder.order_receipt_email_data(order, subject)
      personalization = make_personalization(order.user, data)
      @mail.add_personalization(personalization)
      @sg.client.mail._('send').post(request_body: @mail.to_json)
    end

    def guest_order_receipt_email(order)
      @mail.template_id = 'd-5c23e94785584498835113282036cbb2'
      @mail.from = SendGrid::Email.new(email: @noreply, name: @noreply_title)
      subject = "Your Order Receipt ##{order.reference}"
      @mail.subject = subject
      data = SendgridApi::EmailBuilder.guest_order_receipt_email_data(order, subject)
      personalization = make_guest_personalization(order, data)
      @mail.add_personalization(personalization)
      @sg.client.mail._('send').post(request_body: @mail.to_json)
    end

    def order_processor_email(order)
      @mail.template_id = 'd-7d3adcc2d4394b63af1e895e47ab9415'
      @mail.from = SendGrid::Email.new(email: @noreply, name: @noreply_title)
      subject = "An order has been placed - ##{order.reference}"
      @mail.subject = subject
      data = SendgridApi::EmailBuilder.processor_email_data(order, subject)
      personalization = self_personalization(data)
      @mail.add_personalization(personalization)
      @sg.client.mail._('send').post(request_body: @mail.to_json)
    end

    def status_processing_email(order, body)
      @mail.template_id = 'd-afa609459c484c19914fb6fe74e3f9a9'
      @mail.from = SendGrid::Email.new(email: @status, name: @status_title)
      subject = "An update on your Order - ##{order.reference}"
      @mail.subject = subject
      data = SendgridApi::EmailBuilder.status_email_builder(order, subject, body)
      personalization = order.user_id.nil? ? make_guest_personalization(order, data) : make_personalization(order.user, data)
      @mail.add_personalization(personalization)
      @sg.client.mail._('send').post(request_body: @mail.to_json)
    end

    # personalizations

    def self_personalization(data)
      personalization = SendGrid::Personalization.new
      personalization.add_to(SendGrid::Email.new(email: 'orders@jazzysburger.com', name: "Operations"))
      personalization.add_dynamic_template_data(JSON.parse(data.to_json))
      personalization
    end

    def make_personalization(user, data)
      personalization = SendGrid::Personalization.new
      personalization.add_to(SendGrid::Email.new(email: user.email, name: user.full_name))
      personalization.add_dynamic_template_data(JSON.parse(data.to_json))
      personalization
    end

    def make_guest_personalization(order, data)
      personalization = SendGrid::Personalization.new
      personalization.add_to(SendGrid::Email.new(email: order.recipient_email, name: order.recipient_name))
      personalization.add_dynamic_template_data(JSON.parse(data.to_json))
      personalization
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

    def set_senders
      @noreply = 'noreply@jazzysjuicyburgers.com'
      @status = 'status@jazzysburger.com'
      @noreply_title = "Jazzy's Burger"
      @status_title = 'Order Status'
    end
  end
end
