# frozen_string_literal: true

# auth controller
class Auth < ApplicationRecord
  has_secure_password
end
