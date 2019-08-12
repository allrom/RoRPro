require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  before do |test|
    unless test.metadata[:not_logged_in]
      login(user) #  controller_helper method
    end
  end

  describe 'GET #show', :not_logged_in do
    before { get :show, params: { id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: answer } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'binds created answer to the associated question' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }

        expect(question.answers).to include(assigns(:answer))
      end

      it 'saves a new answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to \
          change(Answer, :count).by(1)
      end

      it 'redirects to <show>' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(:answer)
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not \
          change(Answer, :count)
      end

      it 're-renders <new>' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
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

      it 'redirects to an updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to assigns(answer)
      end
    end

    context 'with invalid attributes' do
      before {
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), question_id: question }
      }

      it 'doesn\'t change an answer' do
        answer.reload

        expect(answer.body).to eq 'BotAnswer'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }

    it 'deletes a question' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to <question>' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path
    end
  end
end
