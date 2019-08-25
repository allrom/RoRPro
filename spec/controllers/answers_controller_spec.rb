require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user }
  let(:visitor_question) { create :question, :with_answers, user: visitor }
  let(:visitor_answer) { create :answer, question: question, user: visitor }

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
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }

        expect(question.answers).to include(assigns(:answer))
      end

      it 'saves a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to \
          change(Answer, :count).by(1)
      end

      it 'processes js to create new answer' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes', :logged_in do
      it 'doesn\'t save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not \
          change(Answer, :count)
      end

      it 'renders "create" template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
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
        patch :update,
              params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js
        expect(assigns(:answer).question).to eq answer.question
      end

      it ' assigns to be updated answer to same @answer' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'changes a answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'CorrectString'} }, format: :js
        answer.reload
        expect(answer.body).to eq 'CorrectString'
      end

      it 'renders "update" template' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes', :logged_in do
      it 'doesn\'t change an answer' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        answer.reload
        expect(answer.body).not_to eq nil
      end

      it 're-renders "update" view' do
        patch :update,
              params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #flag_best' do
    context 'into authors question', :logged_in do
      it 'sets the visitors answer as "best"' do
        patch :flag_best, params: { id: visitor_answer }, format: :js
        visitor_answer.reload
        expect(visitor_answer).to be_best
      end
      it 'processes js to rearrange' do
        patch :flag_best, params: { id: visitor_answer }, format: :js
        expect(response).to render_template :flag_best
      end
    end

    context 'into visitors question', :logged_in do
      it 'leaves the visitors answer intact' do
        patch :flag_best, params: { id: visitor_question.answers.first }, format: :js
        visitor_question.answers.first.reload
        expect(visitor_question.answers.first).not_to be_best
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        patch :flag_best, params: { id: answer }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    context 'when logged in', :logged_in do
      it 'deletes a question' do
        expect { delete :destroy, params: { id: answer }, format: :js  }.to change(Answer, :count).by(-1)
      end

      it 'processes js to remove an answer' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
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
