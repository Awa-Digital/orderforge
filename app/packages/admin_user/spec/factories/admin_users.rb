FactoryBot.define do
  factory :admin_user do
    email { "MyString" }
    phone { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    super_user { false }
    password_digest { "MyString" }
    avatar { "MyString" }
  end
end
