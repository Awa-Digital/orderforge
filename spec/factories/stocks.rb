FactoryBot.define do
  factory :stock do
    code { "MyString" }
    name { "MyString" }
    description { "MyString" }
    state { "MyString" }
    expires { false }
    quantity { "9.99" }
  end
end
