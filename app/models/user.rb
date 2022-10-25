class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one :favourite, dependent: :destroy
  has_one :notification_setting, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one :password_reset_token, dependent: :destroy

  has_secure_password
  
  validate :otp_validation

  validates :first_name,
            :last_name,
            :password,
            :password_confirmation,
            :phone_number, presence: true

  validates :email,
            :phone_number, uniqueness: true

  validates :phone_number, length: { is: 13 }
  validates :password, length: { minimum: 8 }


  after_create :generate_attributes, :update_account_verification

  # scope :favourites, -> (user) { where(products.liked:  true)}

  def as_json(options = {})
    # options[:methods] = %i[total]
    options[:except] = %i[created_at updated_at password_digest]
    super
  end
  

  def generate_attributes
    create_favourite unless favourite.present?
    create_notification_setting unless notification_setting.present?
    save_to_sendgrid
  end

  def update_account_verification
    account = AccountVerification.find_by(phone: phone_number)
    account.update(phone_verified: true, user_id: id)
    account.process_email_verification
  end

  def products
    prods = Product.all
    prods.each do |p|
      p.liked = p.liked?(self)
    end
    prods
  end

  def favourites
    products.select { |p| p.liked == true }
  end

  def product(id)
    p = Product.find(id)
    p.liked = p.liked?(self)
    p
  end

  def cart
    @cart = orders.find_by(status: 'initiated')
    if @cart.present?
      @cart
    else
      start_cart
    end
  end

  def start_cart
    orders.find_or_create_by!(status: 'initiated')
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def update_password_reset_token
    password_reset_token.update_token
  end

  def save_to_sendgrid
    # make this asynchronous with retries
    byebug
    Sendgrid.new.add_contacts(self)
    puts '------ Contact saved to Sendgrid!'
  rescue StandardError
    puts "Couldn't save user details to sendgrid"
  end

  private

    def otp_validation
      account = AccountVerification.find_by(phone: phone_number)
      if account
        self.errors[:phone_number] << "is not valid" if !account.valid_phone?
        self.errors[:otp] << "is invalid. Resend new OTP or try again" if account.otp != phone_otp
      else
        self.errors[:account] << "verification not processed yet" if account.otp != phone_otp
      end
    end
end
