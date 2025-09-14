# Preview all emails at http://localhost:3000/rails/mailers/otp_mailer
class OtpMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/otp_mailer/otp

  def otp
    user = AccountVerification.last

    OtpMailer.with(account: user).otp
  end
end
