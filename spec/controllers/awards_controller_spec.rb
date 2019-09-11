require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create :user, :with_award }

  describe 'GET #index' do
    context 'when user logged in' do
      it 'renders index view' do
        login(user)
        get :index
        expect(response).to render_template :index
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
