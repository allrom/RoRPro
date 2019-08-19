require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  before do |test|
    if test.metadata[:logged_in]
      login(user) #  controller_helper method
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'renders new view', :logged_in do
      expect(response).to render_template :new
    end

    it 'redirects to login if unauthorized' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'renders edit view', :logged_in do
      expect(response).to render_template :edit
    end

    it 'redirects to login if unauthorized' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes', :logged_in do
      it 'binds created answer to the associated question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(question.answers).to include(assigns(:answer))
      end

      it 'saves a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to \
          change(Answer, :count).by(1)
      end

      it 'redirects to <show> question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes', :logged_in do
      it 'doesn\'t save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not \
          change(Answer, :count)
      end

      it 'renders <show> question' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template("questions/show")
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to_not \
          change(Answer, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes', :logged_in do
      it 'binds updated answer to the associated question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).question).to eq answer.question
      end

      it ' assigns to be updated answer to same @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes a answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'CorrectString'} }
        answer.reload
        expect(answer.body).to eq 'CorrectString'
      end

      it 'redirects to an updated question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(id: answer.question_id)
      end
    end

    context 'with invalid attributes', :logged_in do
      before {
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }
      }

      it 'doesn\'t change an answer' do
        answer.reload
        expect(answer.body).not_to eq nil
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'when not logged in' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question } }
      it 'redirects to login if unauthorized' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'when logged in', :logged_in do
      it 'deletes a question' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to <question>' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(id: answer.question_id)
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
