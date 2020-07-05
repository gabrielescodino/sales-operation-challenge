require 'rails_helper'

RSpec.describe SalesReportDecorator do
  let(:input_file) do
    fixture_file_upload(Rails.root.join('spec/fixtures/files/sales_report_sample.tab'), 'image/txt')
  end

  let(:sales_report) { create(:sales_report, :finished, income: 10000, input_file: input_file) }

  subject { described_class.new(sales_report) }

  describe '#created_at' do
    it 'returns decorated created_at' do
      expect(subject.created_at).to eq('05/07/20 - 00:00')
    end
  end

  describe '#status' do
    it 'returns decorated status' do
      expect(subject.status).to eq('Finished')
    end
  end

  describe '#income' do
    it 'returns decorated income' do
      expect(subject.income).to eq('$100.00')
    end
  end
end
