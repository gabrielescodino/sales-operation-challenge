class AddSalesReportReferenceToSales < ActiveRecord::Migration[6.0]
  def change
    add_reference :sales, :sales_report, foreign_key: true, index: true
  end
end
