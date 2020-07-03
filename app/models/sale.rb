# frozen_string_literal: true

class Sale < ApplicationRecord
  # :: Associations
  belongs_to :customer
  belongs_to :merchant
  belongs_to :item
  belongs_to :sales_report

  # :: Delegates
  delegate :description,    to: :item,      prefix: true, allow_nil: true
  delegate :name, :address, to: :merchant,  prefix: true, allow_nil: true
  delegate :name,           to: :customer, prefix: true, allow_nil: true

  # :: Validations
  validates :item_price, :purchase_count, presence: true

  # :: Methods
  def self.calculate_income
    sum { |sale| sale.item_price * sale.purchase_count }
  end
end
