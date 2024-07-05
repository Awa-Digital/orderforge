# frozen_string_literal: true

module Mutations
  class CreateVoucher < BaseMutation
    description "Add a new discount code"
    argument :title, String
    argument :discount_code, String
    argument :influencer_id, Integer
    argument :discount_rate, Float

    type Types::VoucherType

    def resolve(influencer_id, **attributes)
      Influencer.find(influencer_id).vouchers.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
