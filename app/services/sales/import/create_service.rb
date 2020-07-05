# frozen_string_literal: true

require 'csv'

module Sales
  module Import
    class CreateService
      def initialize(sales_report)
        @sales_report = SalesReport.find(sales_report.id)
      end

      def execute!
        ActiveRecord::Base.transaction do
          table = CSV.parse(@sales_report.input_file.download, { col_sep: "\t", headers: true })
          table.each do |row|
            import_sale!(row)
          end

          sales_report.update!(income: @sales_report.sales.calculate_income)
          sales_report.change_to_finished!
        end
      rescue StandardError
        sales_report.change_to_error!
      end

      private

      attr_accessor :sales_report

      def handle_item_price(price)
        # Use BigDecimal instead of ".to_f" is a decision to cover problems that
        # could appear when handling huge numbers
        (BigDecimal(price) * 100).round
      end

      def import_sale!(row)
        customer       = Customer.find_or_create_by!(name: row['purchaser name'])
        item           = Item.find_or_create_by!(description: row['item description'])
        item_price     = handle_item_price(row['item price'])
        purchase_count = row['purchase count'].to_i

        merchant = Merchant.find_or_create_by!(name: row['merchant name']) do |merchant|
          merchant.address = row['merchant address']
        end

        Sale.create!(customer_id: customer.id, item_id: item.id, item_price: item_price,
                     purchase_count: purchase_count, merchant_id: merchant.id, sales_report_id: @sales_report.id)
      end
    end
  end
end
