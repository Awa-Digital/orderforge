
# for User Addresses
class Api::V1::Profile::LeaderController < Api::V1::Profile::BaseController
  def board
    @users = User.all.sort(&:total_spends)
    data = make_data(@users)
    success({message: 'Leaderboard fetched successfully', data: data})
  end

  def make_data(users)
    arr = []
    rank = 0
    users.each do |user|
      arr << {
        name: user.full_name,
        amount: user.orders.where(paid: true).sum(&:total),
        rank: rank+1
      }
      rank += 1
    end
    arr
  end
end
