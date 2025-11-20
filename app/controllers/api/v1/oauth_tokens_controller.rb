# frozen_string_literal: true

class Api::V1::OauthTokensController < Api::V1::BaseController
  skip_before_action :authenticate_user

  def token_sign_in
    user = OAuthUserService.for(
      provider: params[:provider],
      id_token: params[:id_token],
      name: params[:name]
    ).call

    generate_auth_token(user)
    render json: { data: { user: user, auth: { token: @token } } }, status: :ok
  rescue ArgumentError, JSON::ParserError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
