class Api::AffiliateController < Api::BaseController
  skip_before_action :authenticate_user, only: [:register_view]

  def register_view
    influencer = Influencer.find_by(slug: params[:affiliate_slug])
    return notfound({}) unless influencer

    AffiliateView.find_or_create_by(
      influencer: influencer,
      ip: request.remote_ip,
      user_agent: request.user_agent
    )

    success(message: "Successfully recorded view.")
  end
end
