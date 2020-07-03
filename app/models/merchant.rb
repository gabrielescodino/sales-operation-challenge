# frozen_string_literal: true

class Merchant < ApplicationRecord
  # :: Validations
  validates :name, :address, presence: true
end
