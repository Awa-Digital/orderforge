# Preview all emails at http://localhost:3000/rails/mailers/influencer_mailer
class InfluencerMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/market_mailer/elearn

  def welcome
    user = Influencer.last

    InfluencerMailer.with(id: user.id).welcome
  end

  def approval
    user = Influencer.last

    InfluencerMailer.with(id: user.id).approval
  end
end
