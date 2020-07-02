module SalesReportStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm(:status) do
      state :initial, initial: true
      state :pending, :finished, :error

      event :change_to_pending do
        transitions from: :initial, to: :pending
      end

      event :change_to_finished do
        transitions from: :pending, to: :finished
      end

      event :change_to_error do
        transitions from: %i[initial pending finished], to: :error
      end
    end
  end
end
