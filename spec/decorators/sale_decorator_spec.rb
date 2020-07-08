require 'rails_helper'

RSpec.describe SaleDecorator do
  let(:sales) { create(:sale) }

  subject { described_class.new(sales) }

  describe '#created_at' do
    it 'returns decorated created_at' do
      expect(subject.created_at).to eq('07/07/20 - 00:00')
    end
  end

  describe '#item_price' do
    it 'returns decorated item_price' do
      expect(subject.item_price).to eq('$100.00')
    end
  end
end
