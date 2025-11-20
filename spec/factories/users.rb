FactoryBot.define do
  factory :user do
    first_name { "Uchenna" }
    last_name { "Mba" }
    sequence(:email) { |n| "user#{n}@example.com" }
    phone_number { "2349012345561" }
    password { "SamplePassword@1" }
    password_confirmation { "SamplePassword@1" }
    phone_otp { "2225" }

    after(:build) do |user|
      account = AccountVerification.find_or_initialize_by(phone: user.phone_number)
      account.email = user.email
      account.save!(validate: false) if account.new_record?
      account.update_columns(otp: user.phone_otp)
    end
  end
end

# 234 9012345561
