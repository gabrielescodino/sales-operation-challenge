require 'rails_helper'

RSpec.describe Sales::Import::CreateService, type: :model do
  include ActiveJob::TestHelper

  describe '#execute' do
    let(:user) { create(:user) }
    let!(:sales_report) { create(:sales_report, input_file: input_file, user: user, status: 'pending') }

    subject { described_class.new(sales_report).execute! }

    context 'when sales report has a valid file' do
      let(:input_file) do
        fixture_file_upload(Rails.root.join('spec/fixtures/files/sales_report_sample.tab'), 'image/txt')
      end

      it 'import file from sales report and create sales' do
        expect { subject }.to change { Sale.count }.by(4)
      end

      it 'updates sales report income' do
        subject

        expect(sales_report.reload.income).to eq(9500)
      end

      it 'updates sales report status to finished' do
        subject

        expect(sales_report.reload.status).to eq('finished')
      end
    end

    context 'when sales import has an invalid file' do
      let(:input_file) do
        fixture_file_upload(Rails.root.join('spec/fixtures/files/invalid_sales_report_sample.tab'), 'image/txt')
      end

      it 'does not create any sales' do
        subject

        expect { subject }.not_to change { Sale.count }
      end

      it 'does not updates sales report income' do
        subject

        expect(sales_report.reload.income).to eq(0)
      end

      it 'updates sales report status to error' do
        subject

        expect(sales_report.reload.status).to eq('error')
      end
    end
  end
end
