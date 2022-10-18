require 'sendgrid-ruby'

class EmailSender
  def initialize
    @sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  end

  def welcome_email(notification)
    sendmail = sendmail(
      "d-a24c996883234ff5978937466d629ad6", 
      "eva@yaaaga.com", 
      "Eva from Yaaaga", 
      "Welcome to Yaaaga"
    )

    personalization = SendGrid::Personalization.new
    personalization.add_to(SendGrid::Email.new(
      email: notification[:email], 
      name: notification[:first_name]))
    personalization.add_dynamic_template_data({
      "subject" => "Welcome to Yaaaga",
      "first_name" => notification[:first_name],
      "email" => notification[:email],
      "confirmation_link" => notification[:confirmation_url]
    })
    sendmail.add_personalization(personalization)
    response = @sg.client.mail._('send').post(request_body: sendmail.to_json)
    return "Welcome Email Sent ✅"
    
  end

  def verify_email(reciever_email, name, url)
    mail = SendGrid::Mail.new
    mail.template_id = 'd-3c17f4bf236a4fb7b8eb036660027630'
    mail.from = SendGrid::Email.new(email: 'no-reply@mystem.ng', name: 'Stem')
    subject = 'Verify Your Email for Stem'
    mail.subject = subject
    personalization = SendGrid::Personalization.new
    personalization.add_to(SendGrid::Email.new(email: reciever_email, name: name))
    personalization.add_dynamic_template_data({
      "subject" => subject,
      "first_name" => name,
      "email" => reciever_email,
      "confirm_url" => url
    })
    mail.add_personalization(personalization)
    response = @sg.client.mail._('send').post(request_body: mail.to_json)
    print response
  end

  def sendmail(template_id, sender_email, sender_name, subject)
    mail = SendGrid::Mail.new
    mail.template_id = template_id
    mail.from = SendGrid::Email.new(email: sender_email, name: sender_name)
    # subject = transaction.subject
    mail.subject = subject
    mail
  end

  def transaction(transaction)
    mail = SendGrid::Mail.new
    mail.template_id = 'd-f2cc00c58f6845c5a8789e6bc695947e'
    mail.from = SendGrid::Email.new(email: 'transactions@mystem.ng', name: 'Stem')
    subject = transaction.subject
    mail.subject = subject
    personalization = SendGrid::Personalization.new
    personalization.add_to(SendGrid::Email.new(email: transaction.user.email, name: transaction.user.first_name))
    personalization.add_dynamic_template_data({
      "subject" => transaction.subject,
      "first_name" => transaction.user.first_name,
      "email" => transaction.user.email,
      "description" => transaction.slug_desc,
      "provider" => transaction.provider,
      "reference" => transaction.ref,
      "unit_price" => ActionController::Base.helpers.number_to_currency(transaction.unit_price, unit: '₦', separator: '.', delimiter: ',', precision: 2),
      "units" => transaction.units,
      "total" => ActionController::Base.helpers.number_to_currency(transaction.total, unit: '₦', separator: '.', delimiter: ',', precision: 2),
      "date" => transaction.created_at.strftime("%^A %^b %d, %Y")
    })
    mail.add_personalization(personalization)
    response = @sg.client.mail._('send').post(request_body: mail.to_json)
    return "Notification Email Sent ✅"
  end

  def init(reciever_email, subject, content, email_type)
    from = SendGrid::Email.new(email: 'uchenna@callphoneng.com')
    to = SendGrid::Email.new(email: reciever_email)
    subject = subject
    content = SendGrid::Content.new(type: email_type, value: content)
    mail = SendGrid::Mail.new(from, subject, to, content)
    return mail
  end
end
