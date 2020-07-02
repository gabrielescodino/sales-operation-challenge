# frozen_string_literal: true

class User < ApplicationRecord
  # :: Associations
  has_many :sales_reports, dependent: :destroy
  has_many :sales, through: :sales_reports

  # :: Validations
  validates :name, :email, presence: true
  validates :email, :google_uid, uniqueness: true
end
