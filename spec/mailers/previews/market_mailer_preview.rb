# Preview all emails at http://localhost:3000/rails/mailers/market_mailer
class MarketMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/market_mailer/elearn

  def elearn
    user = User.first

    MarketMailer.with(user:).elearn
  end
end
