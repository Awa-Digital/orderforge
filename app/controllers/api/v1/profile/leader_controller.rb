
# for User Addresses
class Api::V1::Profile::LeaderController < Api::V1::Profile::BaseController
  skip_before_action :authenticate_user
  before_action :authenticate_guest
  def board
    @users = User.all.order(spend_score: :desc).limit(10)
    data = make_data(@users)
    success({message: 'Leaderboard fetched successfully', data: data})
  end

  def make_data(users)
    arr = []
    rank = 0
    users.each do |user|
      arr << {
        image: user.avatar,
        name: user.full_name.camelize,
        amount: user.orders.where(paid: true).sum(&:total),
        rank: rank+1
      }
      rank += 1
    end
    arr
  end
end
