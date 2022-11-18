class AccountVerification < ApplicationRecord
  validates :phone, :email, presence: true
  validates :phone, :email, uniqueness: true

  # after_save :deliver_otp
  before_create :develop_otp

  def develop_otp
    self.otp = rand(1000..9999)
  end

  def deliver_otp
    TermiiSms.new.send_otp(phone, otp)
  end

  def generate_email_token
    update(email_token: Digest::SHA256.hexdigest(email + Time.now.to_s))
  end

  def valid_account?
    valid_phone? && valid_email?
  end

  def valid_phone?
    !User.find_by(phone_number: phone).present?
  end

  def valid_email?
    !User.find_by(email: email).present?
  end

  def user
    User.find_by(id: user_id)
  end

  def process_email_verification
    generate_email_token
    send_email_verification
  end

  def send_email_verification
    SendgridApi::Email.new.verify_email(self.user)
    puts 'Email for account verification has been sent! ---- '
  end
end
