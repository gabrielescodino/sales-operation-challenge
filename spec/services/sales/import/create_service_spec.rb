require 'rails_helper'

RSpec.describe Sales::Import::CreateService, type: :model do
  include ActiveJob::TestHelper

  describe '#execute' do
    let(:user) { create(:user) }
    context 'when sales report has a valid file' do
      subject do
        input_file = fixture_file_upload(Rails.root.join('spec/fixtures/files/example_input.tab'), 'image/txt')
        create(:sales_report, input_file: input_file, user: user, status: 'pending')
      end

      it 'import file from sales report and create sales' do
        SalesImportService.new(subject.id).process!

        expect(user.sales.count).to eq(4)
      end

      it 'updates sales report income' do
        SalesImportService.new(subject.id).process!
        sales_report = SalesReport.find(subject.id)

        expect(sales_report.income).to eq(9500)
      end

      it 'updates sales report status to finished' do
        SalesImportService.new(subject.id).process!
        sales_report = SalesReport.find(subject.id)

        expect(sales_report.status).to eq('finished')
      end
    end

    context 'when sales import has an invalid file' do
      subject do
        input_file = fixture_file_upload(Rails.root.join('spec/fixtures/files/invalid_example_input.txt'), 'image/txt')
        create(:sales_report, input_file: input_file, status: 'pending')
      end

      it 'does not create any sales' do
        SalesImportService.new(subject.id).process!
        expect(Sale.count).to eq(0)
      end

      it 'does not updates sales report income' do
        SalesImportService.new(subject.id).process!
        sales_report = SalesReport.find(subject.id)

        expect(sales_report.income).to eq(0)
      end

      it 'updates sales report status to error' do
        SalesImportService.new(subject.id).process!
        sales_report = SalesReport.find(subject.id)

        expect(sales_report.status).to eq('error')
      end
    end
  end
end
