require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:all) do
    @email = "#{Time.now.to_i}@example.com"
    @phone = "23480#{rand(10_000_000..99_999_999)}"
    @user_attributes = FactoryBot.attributes_for(:user, email: @email, phone_number: @phone)
    @otp = create(:account_verification, email: @email, phone: @phone).otp
  end

  describe 'POST #signup' do
    context 'with valid parameters' do
      it 'creates a new user and returns a success message' do
        post :signup, params: { user: @user_attributes.merge(phone_otp: @otp) }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['status']).to eq('success')
        expect(JSON.parse(response.body)['message']).to eq("Uchenna, welcome to Jazzy's Juicy Burger!")
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user and returns an error message' do
        @otp = create(:account_verification, email: "#{Time.now.to_i + 2}@example.com", phone: @phone).otp
        post :signup, params: { user: @user_attributes.merge(phone_number: @phone) }
        # byebug

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to eq('unprocessable')
      end
    end

    context 'with invalid OTP' do
      it 'returns an OTP validation error' do
        post :signup, params: { user: @user_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']).to include('Otp is invalid')
      end
    end
  end
end
