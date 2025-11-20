FactoryBot.define do
  factory :wallet do
    association :franchise
    available_balance_cents { 0 }
    pending_balance_cents { 0 }
  end

  factory :wallet_transaction do
    association :wallet
    amount_cents { 1000 }
    kind { 'credit_pending' }
    sequence(:reference) { |n| "wtx_#{n}" }
  end

  factory :auth_identity do
    association :user
    provider { 'google' }
    sequence(:uid) { |n| "google_uid_#{n}" }
    info { { 'email' => user.email } }
  end

  factory :franchise_page_visit do
    association :franchise
    visitor_uuid { SecureRandom.uuid }
  end
end
