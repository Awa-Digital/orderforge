class Api::V1::AdsController < Api::V1::BaseController
  skip_before_action :authenticate_user

  def ads
    ads = Ad.active_ads
    success({message: "Ads successfully fetched", data: ads})
  end
end