# for User Addresses
class Api::V1::Profile::LeaderController < Api::V1::Profile::BaseController
  skip_before_action :authenticate_user
  before_action :authenticate_guest
  def board
    @users = User.order(spend_score: :desc).limit(10)
    data = make_data(@users)
    success({ message: 'Leaderboard fetched successfully', data: })
  end

  def make_data(users)
    arr = []
    users.each do |user|
      total_amount = user.orders.select(&:paid).sum(&:total)
      arr << {
        image: user.avatar,
        name: user.first_name.camelize,
        amount: total_amount,
      }
    end

    sorted = arr.sort_by { |user| -user[:amount] }.each_with_index do |user, index|
      user[:rank] = index + 1
    end

    sorted
  end

end