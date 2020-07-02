require 'csv'

module Sales
  module Import
    class CreateService
      def initialize(sales_report)
        @sales_report = SalesReport.find(sales_report)
      end

      def execute
        ActiveRecord::Base.transaction do
          lines = @sales_report.input_file.download.split("\n")

          lines.each.with_index do |line, index|
            next if index.zero?

            row = line.split("\t")
            create_sale!(row)
          end
          @sales_report.update!(income: @sales_report.sales.calculate_income)
          @sales_report.change_to_finished!
        end
      rescue StandardError
        @sales_report.change_to_error!
      end

      private

      attr_reader :sales_report

      def handle_item_price(price)
        # Usar BigDecimal ao invés de ".to_f" é uma decisão para cobrir
        # intermitências que podem surgir ao utilizar números grandes.
        (BigDecimal(price) * 100).round
      end

      def create_sale!(row)
        purchaser      = Purchaser.find_or_create_by!(name: row[0])
        item           = Item.find_or_create_by!(description: row[1])
        item_price     = handle_item_price(row[2])
        purchase_count = row[3].to_i

        merchant = Merchant.find_or_create_by!(name: row[5]) do |merchant|
          merchant.address = row[4]
        end

        Sale.create!(purchaser_id: purchaser.id,
                     item_id: item.id,
                     item_price: item_price,
                     purchase_count: purchase_count,
                     merchant_id: merchant.id,
                     sales_report_id: @sales_report.id)
      end
    end
  end
end