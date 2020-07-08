# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'sales index', type: :request do
  let(:user) { create(:user) }
  let(:valid_session) { { user_id: user.id } }

  # GET /sales
  context 'when all params are valid' do
    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    let(:input_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/sales_report_sample.tab'), 'image/txt') }
    let!(:sales_report) { create(:sales_report, status: 'finished', input_file: input_file, user: user) }

    subject { get sales_path }

    before { 5.times { create(:sale, sales_report: sales_report) } }

    it 'returns a successful response with correct data' do
      subject

      expect(response).to have_http_status(200)
      expect(response.body).to include('5 sales imported by John Doe')
    end
  end
end
