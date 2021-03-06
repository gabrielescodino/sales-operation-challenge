# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'sales_report create', type: :request do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }

  before(:each) do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  # POST /sales_reports
  context 'when all params are valid' do
    let(:input_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/sales_report_sample.tab'), 'image/txt') }

    let(:params) do
      {
        sales_report: {
          input_file: input_file
        }
      }
    end

    subject { post sales_reports_path, params: params }

    it 'returns a successful response with correct data', perform_enqueued: true do
      subject

      perform_enqueued_jobs { SalesImporterJob.perform_later(SalesReport.first.id) }

      expect([user.sales_reports.count, user.sales.count, Customer.count,
              Merchant.count, Item.count]).to eq([1, 4, 4, 3, 3])

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(sales_reports_path)
    end
  end

  context 'when input_file is not valid' do
    let(:input_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/invalid_sales_report_sample.tab'), 'image/txt') }

    let(:params) do
      {
        sales_report: {
          input_file: input_file
        }
      }
    end

    subject { post sales_reports_path, params: params }

    it 'redirects to sales_reports path but do not create sale and its associations', perform_enqueued: true do
      subject

      perform_enqueued_jobs { SalesImporterJob.perform_later(SalesReport.first.id) }

      expect([user.sales_reports.count, user.sales.count, Customer.count,
              Merchant.count, Item.count]).to eq([1, 0, 0, 0, 0])

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(sales_reports_path)
    end
  end
end
