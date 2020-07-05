# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'sales_report index', type: :request do
  let(:user) { create(:user) }
  let(:valid_session) { { user_id: user.id } }

  # GET /sales_reports
  context 'when all params are valid' do
    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    let(:input_file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/example_input.tab'), 'image/txt') }

    subject { get sales_reports_path }

    before { 5.times { create(:sales_report, user: user, input_file: @input_file) } }

    it '' do
      subject

      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
      expect(response.body).to include('5 sales reports imported by John Doe')
    end
  end
end
