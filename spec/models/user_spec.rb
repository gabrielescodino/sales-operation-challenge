require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    context 'presence' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }
    end

    context 'uniqueness' do
      it { should validate_uniqueness_of(:email) }
      it { should validate_uniqueness_of(:google_uid) }
    end
  end
end
