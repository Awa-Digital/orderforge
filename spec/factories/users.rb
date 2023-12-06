FactoryBot.define do
  factory :user do
    first_name { "Uchenna" }
    last_name { "Mba" }
    sequence(:email) { |n| "user#{n}@example.com" }
    phone_number { "2349012345561" }
    password { "SamplePassword@1" }
    password_confirmation { "SamplePassword@1" }
    phone_otp { "2225" }
  end
end

# 234 9012345561
