# frozen_string_literal: true

class SalesImporterJob < ApplicationJob
  queue_as :sales_import

  def perform(sales_report_id)
    sales_report = SalesReport.find(sales_report_id)
    Sales::Import::CreateService.new(sales_report).execute!
  end
end
