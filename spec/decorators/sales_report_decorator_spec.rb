require 'rails_helper'

RSpec.describe SalesReportDecorator do
  let(:sales_report) { create(:sales_report, :finished, income: 10000) }

  subject { described_class.new(sales_report) }

  describe '#created_at' do
    it 'returns decorated created_at' do
      expect(subject.created_at).to eql('05/07/20 - 00:00')
    end
  end

  describe '#status' do
    it 'returns decorated status' do
      expect(subject.status).to eql('Finished')
    end
  end

  describe '#income' do
    it 'returns decorated income' do
      expect(subject.income).to eql('$100.00')
    end
  end
end
