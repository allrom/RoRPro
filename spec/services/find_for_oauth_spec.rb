require 'rails_helper'

RSpec.describe Services::FindForOauth do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234567') }
  let(:authorization) { FactoryBot.create(:authorization, user: user, uid: '1234567', provider: 'github') }

  subject { Services::FindForOauth.new(auth) }

  context 'user has been authorized' do
    it 'finds and returns the user' do
      authorization

      expect(subject.call).to eq user
    end
  end

  context 'user has not been authorized' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '1234567', info: { email: user.email }) }

      it 'does not re-create the user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'creates users authorization record' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates exact this authorization record with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) {
        OmniAuth::AuthHash.new(provider: 'github',
                               uid: '1234567',
                               info: { email: 'new_user@test.edu' })
      }
      it 'creates a new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns a new user' do
        expect(subject.call).to be_a(User)
      end

      it 'fills a new user email' do
        user = subject.call
        expect(user.email).to eq auth.info[:email]
      end

      it 'creates authorization for a user' do
        user = subject.call
        expect(user.authorizations).to_not be_empty
      end

      it 'creates exact this authorization record with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
