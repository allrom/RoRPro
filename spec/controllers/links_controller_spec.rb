require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let!(:user_question_w_link) { create :question, :with_link, user: user }
  let!(:visitor_question_w_link) { create :question, :with_link, user: visitor }
  let!(:user_answer_w_link) {
    create :answer, :with_link, question: user_question_w_link, user: user
  }
  let!(:visitor_answer_w_link) {
    create :answer, :with_link, question: visitor_question_w_link, user: visitor
  }

  before do |test|
    if test.metadata[:logged_in]
      login(user)
    end
  end

  describe 'DELETE #destroy' do
    context 'when user logged in', :logged_in do
      it 'deletes link binded to own question' do
        expect { delete :destroy, params: { id: user_question_w_link.links.first }, format: :js }.to \
          change(Link, :count).by(-1)
      end

      it 'processes js to remove a link from question' do
        delete :destroy, params: { id: user_question_w_link.links.first }, format: :js
        expect(user_question_w_link.links.count).to eq(0)
      end

      it 'deletes link binded  to own answer' do
        expect { delete :destroy, params: { id: user_answer_w_link.links.first }, format: :js }.to \
        change(Link, :count).by(-1)
      end

      it 'processes js to remove a link from answer' do
        delete :destroy, params: { id: user_answer_w_link.links.first }, format: :js
        expect(user_answer_w_link.links.count).to eq(0)
      end

      it 'tries to remove link binded to visitors question' do
        expect { delete :destroy, params: { id: visitor_question_w_link.links.first }, format: :js }.not_to \
          change(Link, :count)
      end

      it 'tries to remove link binded to visitors answer' do
        expect { delete :destroy, params: { id: visitor_answer_w_link.links.first }, format: :js }.not_to \
          change(Link, :count)
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized in question' do
        expect { delete :destroy, params: { id: user_question_w_link.links.first  } }.to_not change(Link, :count)
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to login if unauthorized in answer' do
        expect { delete :destroy, params: { id: user_answer_w_link.links.first  } }.to_not change(Link, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
