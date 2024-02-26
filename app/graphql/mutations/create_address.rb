# frozen_string_literal: true

module Mutations
  class CreateAddress < BaseMutation
    argument :user_id, Integer
    argument :street, String
    argument :state, String
    argument :country, String
    argument :house_number, String
    argument :delivery_area_id, Integer

    type Types::AddressType

    def resolve(user_id:, **attributes)
      User.find(user_id).addresses.create!(attributes)
    end
  end
end
