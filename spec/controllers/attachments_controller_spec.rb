require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let!(:user_question_w_file) { create :question, :with_attachment, user: user }
  let!(:visitor_question_w_file) { create :question, :with_attachment, user: visitor }
  let!(:user_answer_w_file) {
    create :answer, :with_attachment, question: user_question_w_file, user: user
  }
  let!(:visitor_answer_w_file) {
    create :answer, :with_attachment, question: visitor_question_w_file, user: visitor
  }

  before do |test|
    if test.metadata[:logged_in]
      login(user)
    end
  end

  describe 'DELETE #destroy' do
    context 'when user logged in', :logged_in do
      it 'deletes attached file to own question' do
        expect { delete :destroy, params: { id: user_question_w_file.files.first }, format: :js }.to \
          change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'processes js to remove a file from question' do
        delete :destroy, params: { id: user_question_w_file.files.first }, format: :js
        expect(response).to render_template :destroy
      end

      it 'deletes attached file to own answer' do
        expect { delete :destroy, params: { id: user_answer_w_file.files.first }, format: :js }.to \
        change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'processes js to remove a file from answer' do
        delete :destroy, params: { id: user_answer_w_file.files.first }, format: :js
        expect(response).to render_template :destroy
      end

      it 'tries to delete attached file to visitors question' do
        expect { delete :destroy, params: { id: visitor_question_w_file.files.first }, format: :js }.not_to \
          change(ActiveStorage::Attachment, :count)
      end

      it 'tries to delete attached file to visitors answer' do
        expect { delete :destroy, params: { id: visitor_answer_w_file.files.first }, format: :js }.not_to \
          change(ActiveStorage::Attachment, :count)
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized in question' do
        expect { delete :destroy, params: { id: user_question_w_file.files.first  } }.to_not change(ActiveStorage::Attachment, :count)
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'redirects to login if unauthorized in answer' do
        expect { delete :destroy, params: { id: user_answer_w_file.files.first  } }.to_not change(ActiveStorage::Attachment, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
