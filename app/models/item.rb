# frozen_string_literal: true

class Item < ApplicationRecord
  # :: Validations
  validates :description, presence: true
end
