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

      it 'import file from sales report and correctly create sales with its associations' do
        expect { subject }.to change { user.sales.count }.by(4)

        expect(Customer.pluck(:name)).to eq(['João Silva', 'Amy Pond', 'Marty McFly', 'Snake Plissken'])
        expect(Item.pluck(:description, :price)).to eq([['R$10 off R$20 of food', 1000],
                                                        ['R$30 of awesome for R$10', 1000],
                                                        ['R$20 Sneakers for R$5', 500]])

        expect(Merchant.pluck(:name, :address)).to eq([["Bob's Pizza", '987 Fake St'],
                                                       ["Tom's Awesome Shop", '456 Unreal Rd'],
                                                       ['Sneaker Store Emporium', '123 Fake St']])
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

        expect { subject }.not_to change{ user.sales.count }
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
