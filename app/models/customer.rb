# frozen_string_literal: true

class Customer < ApplicationRecord
  # :: Validations
  validates :name, presence: true
end
