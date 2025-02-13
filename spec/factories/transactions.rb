FactoryBot.define do
  factory :transaction do
    transactionable { "MyString" }
    transactionable_type { "MyString" }
    amount { "MyString" }
    reference { "MyString" }
    recipient_code { "MyString" }
    narration { "MyString" }
  end
end
