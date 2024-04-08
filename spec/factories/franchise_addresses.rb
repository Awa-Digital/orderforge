FactoryBot.define do
  factory :franchise_address do
    franchise_id { 1 }
    region_id { 1 }
    location_id { 1 }
    street { "MyString" }
    longitude { "MyString" }
    latitude { "MyString" }
  end
end
