class SalesImporterJob < ApplicationJob
  queue_as :sales_import

  def perform(sales_report)
    Sales::Import::CreateService.new(sales_report).execute!
  end
end
