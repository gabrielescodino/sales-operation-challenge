require 'rails_helper'

RSpec.describe Sale, type: :model do
  describe 'validations' do
    it { should validate_presence_of :item_price }
    it { should validate_presence_of :purchase_count }
  end

  describe 'associations' do
    it { is_expected.to belong_to :merchant }
    it { is_expected.to belong_to :customer }
    it { is_expected.to belong_to :item }
  end
end
