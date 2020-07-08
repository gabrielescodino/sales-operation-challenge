require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe 'validations' do
    it { should validate_presence_of :item_price }
    it { should validate_presence_of :purchase_count }
  end

  describe 'associations' do
    it { is_expected.to belong_to :merchant }
    it { is_expected.to belong_to :customer }
    it { is_expected.to belong_to :item }
  end

  describe '#calculate_income' do
    it 'calculates income of a sale' do
      sales_report = create(:sales_report)
      sale = create(:sale, sales_report: sales_report, item_price: 20000, purchase_count: 10)
      sale2 = create(:sale,sales_report: sales_report, item_price: 100, purchase_count: 0)
      sale2 = create(:sale,sales_report: sales_report, item_price: 0, purchase_count: 54232)

      expect(sales_report.sales.calculate_income).to eq(200000)
    end
  end
end
