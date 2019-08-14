require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  before do |test|
    unless test.metadata[:not_logged_in]
      login(user) #  controller_helper method
    end
    if test.metadata[:is_owner]
      allow(controller).to receive(:author_check).and_return(true)
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

  describe 'GET #edit', :is_owner do
    before { get :edit, params: { id: answer } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create', :is_owner do
    context 'with valid attributes' do
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

    context 'with invalid attributes' do
      it 'doesn\'t save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not \
          change(Answer, :count)
      end

      it 'renders <show> question' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template("questions/show")
      end
    end
  end

  describe 'PATCH #update', :is_owner do
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

      it 'redirects to an updated question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(id: answer.question_id)
      end
    end

    context 'with invalid attributes' do
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
  end

  describe 'DELETE #destroy', :is_owner do
    let!(:answer) { create(:answer) }

    it 'deletes a question' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'redirects to <question>' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(id: answer.question_id)
    end
  end
end
