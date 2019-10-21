require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  providers = Devise.omniauth_providers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  providers.each do |provider|
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: provider.to_s, uid: '123456', info: { email: 'student@test.edu'}) }

    before do |test|
      if test.metadata[:get_oauth_data]
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      end
    end

    describe provider.to_s.capitalize do
      it 'finds the user from oauth data', :get_oauth_data do
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get provider
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get provider
        end

        it 'logins with this user', :get_oauth_data  do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path', :get_oauth_data do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(User).to receive(:find_for_oauth)
          get provider
        end

        it 'redirects to "sign in" path' do
          expect(response).to redirect_to new_user_session_path
        end

        it 'does not login user' do
          expect(subject.current_user).to_not be
        end
      end
    end
  end
end
