class PasswordResetToken < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :user

  before_save :generate_token

  def generate_token
    self.token = Digest::SHA256.hexdigest user.to_s
  end

  def update_token
    generate_token
    save!
  end

  def valid!
    (updated_at + 15.minutes) >= Time.current
  end

  def expire
    destroy
  end
end
