# User Managment
class Api::V1::InfluencerController < Api::V1::BaseController
  skip_before_action :authenticate_user
  before_action :authenticate_influencer, except: [:signup, :login]

  def signup
    @user = Influencer.new(influencer_params)
    @user.email = influencer_params[:email].downcase.gsub(' ', '')
    @user.password = influencer_params[:password]
    @user.password_confirmation = influencer_params[:password]

    unprocessable({ message: 'Add a valid verification document' }) unless (@user.verification_document = make_image(influencer_params[:verification_document]))

    begin
      @user.save!
    rescue StandardError
      unprocessable({ message: "Something went wrong while creating account", data: @user.errors })
    else
      InfluencerMailer.with(id: @user.id).welcome.deliver
      influencer_token(@user)
    end
  end

  def user
    success(data: { user: @user })
  end

  def update_verification_video
    @user.update!(verification_video_url: influencer_params[:verification_video_url])
    success(message: "Verification video updated successfully", data: { user: @user })
  end

  def withdraw
    return unprocessable(message: "You don't have enough money") unless @user.balance > 99

    @user.withdraw(@user.balance)
  rescue StandardError => e
    unprocessable(message: e)
  else
    success(message: "Withdrawal Successful")
  end

  def bank_list
    list = Integrations::Paystack::Accounts.bank_list
    success({ data: list })
  end

  def resolve_account
    result = Integrations::Paystack::Accounts.resolve(params[:account_number], params[:bank_code])
  rescue StandardError => e
    errors = JSON.parse e.message || {}
    unprocessable({ message: "cannot resolve account", errors: })
  else
    success({ data: result["data"] })
  end

  def save_bank
    account = Integrations::Paystack::Accounts.resolve(params[:account_number], params[:bank_code])
    list = Integrations::Paystack::Accounts.bank_list
  rescue StandardError => e
    errors = JSON.parse e.message || {}
    unprocessable({ message: "cannot resolve account", errors: })
  else
    bank = get_bank_from_list(params[:bank_code], list)
    return unprocessable({ message: "Bank doesn't exist" }) unless bank

    update_account_details(account["data"], bank)
  end

  def get_bank_from_list(bank_code, list)
    bank = list["data"].select { |x| x["code"] == bank_code }
    bank.first
  end

  def update_account_details(account, bank)
    @user.add_bank(bank, account)
  rescue StandardError => e
    unprocessable({ message: "Something went wrong", errors: e })
  else
    success({ message: "account saved successfully", data: @user.bank_detail })
  end

  def login
    @user = Influencer.find_by(email: params[:email].downcase.gsub(' ', ''))
    return unauthorized({ message: 'invalid username, email or password' }) unless @user

    return unauthorized({ message: 'invalid username, email or password' }) unless @user.authenticate(params[:password])

    influencer_token(@user)
  end

  def influencer_token(user)
    @token = generate_influencer_token(user)
    success({
              message: "#{user.name}, welcome to Jazzy's Juicy Burger!",
              data: {
                user:,
                auth: {
                  token: @token
                }
              }
            })
  end

  private

  def authenticate_influencer
    authorization_header = request.headers[:authorization]
    return unauthorized({ message: 'Authorization Absent!' }) unless authorization_header

    token = authorization_header.split[1]
    secret_key = ENV.fetch('SECRET_KEY_BASE', nil)
    decode_token(token, secret_key)
  end

  def decode_token(token, secret_key)
    decoded_token = JWT.decode(token, secret_key)
    current_user = Influencer.find(decoded_token[0]['id'])
    return unauthorized({ message: "User not found" }) unless current_user

    Sentry.set_user(
      username: current_user.name,
      email: current_user.email,
      id: current_user.id
    )

    @user = current_user
  rescue JWT::ExpiredSignature
    unauthorized({ message: 'Your session has expired' })
  rescue StandardError
    unauthorized({ message: 'Invalid token' })
  end

  def influencer_params
    params
      .require(:influencer)
      .permit(
        :name,
        :email,
        :password,
        :phone_number,
        :tiktok_handle,
        :instagram_handle,
        :facebook_page_handle,
        :twitter_handle,
        :followers_count,
        :verification_document,
        :verification_type,
        :verification_video_url,
        :type,
        :business_name
      )
  end
end
