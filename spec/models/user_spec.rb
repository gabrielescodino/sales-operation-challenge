require 'rails_helper'

RSpec.describe User, type: :model do
  let(:google_auth) do
    OmniAuth::AuthHash.new(
      'provider' => 'google_oauth2',
      'uid'      => '54321',
      'info'     => {
        'name'       => 'Gabriel',
        'email'      => 'gabrielescodino@gmail.com',
        'first_name' => 'Gabriel',
        'last_name'  => 'Escodino'
      },
      'credentials' => {
        'token'         => 'GDRIVE-TOKEN',
        'refresh_token' => '54321',
        'expires_at'    => 134_851_721_7,
        'expires'       => true
      },
      'extra' => {
        'raw_info' => {
          'id'             => '54321',
          'email'          => 'gabrielescodino@gmail.com',
          'verified_email' => true,
          'name'           => 'Gabriel',
          'given_name'     => 'Gabriel',
          'family_name'    => 'Escodino',
          'link'           => 'https://plus.google.com/1',
          'gender'         => 'male',
          'birthday'       => '0000-10-10',
          'locale'         => 'pt-BR'
        }
      }
    )
  end

  let(:regular) { build(:user, email: 'vehicula@example.com') }

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

  describe '#find_or_create_with_omniauth' do
    context 'when it is a new_user' do
      it 'creates a new instance of user' do
        expect { User.find_or_create_with_omniauth(google_auth) }.to change(User, :count).by(1)
      end

      context 'creates user with data from OmniAuth' do
        subject { User.find_or_create_with_omniauth(google_auth) }

        it '#name' do
          expect(subject.name).to eq('Gabriel')
        end

        it '#email' do
          expect(subject.email).to eq('gabrielescodino@gmail.com')
        end

        it '#google_uid' do
          expect(subject.google_uid).to eq('54321')
        end

        it '#google_token' do
          expect(subject.google_token).to eq('GDRIVE-TOKEN')
        end
      end
    end

    context 'when it is an existing_user' do
      let!(:existing_user) { create(:user, email: 'gabrielescodino@gmail.com',
                                           name: 'Gabriel Escodino',
                                           google_uid: '54321') }

      it 'finds user' do
        expect(User.find_or_create_with_omniauth(google_auth)).to eq(existing_user)
      end

      it 'does not create a new user' do
        expect { User.find_or_create_with_omniauth(google_auth) }.to_not change(User, :count)
      end

      context 'data' do
        before { User.find_or_create_with_omniauth(google_auth) }

        subject { existing_user.reload }

        it '#name' do
          expect(subject.name).to eq('Gabriel')
        end

        it '#email' do
          expect(subject.email).to eq('gabrielescodino@gmail.com')
        end

        it '#google_uid' do
          expect(subject.google_uid).to eq('54321')
        end

        it '#google_token' do
          expect(subject.google_token).to eq('GDRIVE-TOKEN')
        end
      end
    end
  end
end
