require 'rails_helper'

RSpec.describe SalesReport, type: :model do
  include ActiveJob::TestHelper

  describe 'validations' do
    it { should validate_presence_of :income }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end

  describe '#enqueue_process!' do
    subject do
      input_file = fixture_file_upload(Rails.root.join('spec/fixtures/files/example_input.tab'), 'image/txt')
      create(:sales_report, input_file: input_file)
    end

    it 'updates status to pending' do
      subject.enqueue_process!

      expect(subject.status).to eq('pending')
    end

    it 'enqueues SalesImporterJob' do
      expect { subject.enqueue_process! }.to have_enqueued_job(SalesImporterJob)
    end
  end
end
