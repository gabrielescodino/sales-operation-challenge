require 'rails_helper'

RSpec.describe SalesReport, type: :model do
  include ActiveJob::TestHelper

  describe 'validations' do
    it { should validate_presence_of :income }
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
  end
end
