class Transaction < ApplicationRecord
  belongs_to :transactionable, polymorphic: true

  def amount_in_kobo
    amount.to_f * 100
  end
end
