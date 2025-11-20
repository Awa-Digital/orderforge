FactoryBot.define do
  factory :payment do
    total { 1500.0 }
    paid { false }
    status { 'pending' }
    association :order
    sequence(:reference) { |n| "PAY#{n}#{Time.current.to_i}" }
  end
end
