module StateManagement
  extend ActiveSupport::Concern

  included do
    include AASM

    default_scope { where(status: "active") }

    aasm column: 'status' do
      state :active, initial: true
      state :archived

      event :activate do
        transitions to: :active # , after: :send_approval_email
      end

      event :archive do
        transitions to: :archived
      end
    end
  end
end
