FactoryBot.define do
  factory :inventory do
    code { "MyString" }
    name { "MyString" }
    expires { false }
    quantity { "9.99" }
  end
end
