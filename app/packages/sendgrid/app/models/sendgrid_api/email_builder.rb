# frozen_string_literal: true

module SendgridApi
  # Sending Emails
  class EmailBuilder
    def verification_email_data(user)
      {
        first_name: user.first_name,
        verification_url: user.verification_url,
        preheader: 'Please verify your email address to get access to order receipts, offers and exclusive burger deals.'
      }
    end
  end
end
