FactoryBot.define do
  factory :report do
    admin_user_id { 1 }
    file_name { "MyString" }
    csv_url { "MyString" }
    filters { "" }
  end
end
