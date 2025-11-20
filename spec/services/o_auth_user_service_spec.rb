# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OAuthUserService do
  describe 'Google sign-in' do
    let(:payload) { { 'sub' => 'google-123', 'email' => 'oauth@example.com', 'name' => 'OAuth User' } }
    let(:segment) { Base64.urlsafe_encode64(payload.to_json, padding: false) }
    let(:id_token) { "header.#{segment}.signature" }

    it 'creates a user and auth identity' do
      expect do
        described_class.for(provider: 'google', id_token: id_token).call
      end.to change(User, :count).by(1)
         .and change(AuthIdentity, :count).by(1)

      identity = AuthIdentity.last
      expect(identity.provider).to eq('google')
      expect(identity.user.email).to eq('oauth@example.com')
    end

    it 'reuses existing user by email' do
      user = create(:user, email: 'oauth@example.com')
      result = described_class.for(provider: 'google', id_token: id_token).call
      expect(result.id).to eq(user.id)
    end
  end
end
