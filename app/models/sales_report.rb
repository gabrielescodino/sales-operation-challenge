# frozen_string_literal: true

class SalesReport < ApplicationRecord
  include SalesReportStateMachine

  # :: Associations
  belongs_to :user
  has_many :sales, dependent: :destroy

  has_one_attached :input_file

  # :: Validations
  validates :income, :status, presence: true

  # :: Methods
  def enqueue_process!
    change_to_pending!
    SalesImporterJob.perform_later(id)
  end
end
