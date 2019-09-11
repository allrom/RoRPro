require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let!(:user_question) { create :question, :with_link, user: user }
  let!(:visitor_question) { create :question, :with_link, user: visitor }
  let!(:user_answer) {
    create :answer, :with_link, question: user_question, user: user
  }
  let!(:visitor_answer) {
    create :answer, :with_link, question: visitor_question, user: visitor
  }

  before do |test|
    if test.metadata[:logged_in]
      login(user)
    end
  end

  describe 'DELETE #destroy' do
    context 'when user logged in', :logged_in do
      it 'deletes link binded to own question' do
        expect { delete :destroy, params: { id: user_question.links.first }, format: :js }.to \
          change(Link, :count).by(-1)
      end

      it 'renders "destroy" template' do
        delete :destroy, params: { id: user_question.links.first }, format: :js
        expect(user_question.links.count).to eq(0)
      end

      it 'deletes link binded  to own answer' do
        expect { delete :destroy, params: { id: user_answer.links.first }, format: :js }.to \
        change(Link, :count).by(-1)
      end

      it 'renders "destroy" template' do
        delete :destroy, params: { id: user_answer.links.first }, format: :js
        expect(user_answer.links.count).to eq(0)
      end

      it 'tries to remove link binded to visitors question' do
        expect { delete :destroy, params: { id: visitor_question.links.first }, format: :js }.not_to \
          change(Link, :count)
      end

      it 'tries to remove link binded to visitors answer' do
        expect { delete :destroy, params: { id: visitor_answer.links.first }, format: :js }.not_to \
          change(Link, :count)
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized in question' do
        expect { delete :destroy, params: { id: user_question.links.first  } }.to_not change(Link, :count)
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to login if unauthorized in answer' do
        expect { delete :destroy, params: { id: user_answer.links.first  } }.to_not change(Link, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
