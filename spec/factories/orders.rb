FactoryBot.define do
  factory :order do
    status { 'initiated' }
    paid { false }
    total { 0.0 }
    recipient_name { 'Test User' }
    recipient_phone { '2349012345561' }
    recipient_email { 'order@example.com' }
    association :user
    association :franchise

    trait :with_payment do
      after(:create) do |order|
        create(:payment, order: order, total: order.total)
      end
    end
  end
end
