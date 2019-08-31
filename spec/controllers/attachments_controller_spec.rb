require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question_w_file) { create :question, :with_attachment, user: user }

  before do |test|
    if test.metadata[:logged_in]
      login(user)
    end
  end

  describe 'DELETE #destroy' do
    context 'when logged in', :logged_in do
      it 'has attached file' do
        expect(question_w_file.files).to be_attached
      end

      it 'deletes attached file' do
        expect { delete :destroy, params: { id: question_w_file.files.first }, format: :js }.to \
          change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'processes js to remove a file' do
        delete :destroy, params: { id: question_w_file.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        expect { delete :destroy, params: { id: question_w_file.files.first  } }.to_not change(ActiveStorage::Attachment, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
