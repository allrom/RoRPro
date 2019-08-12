require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let (:user) { create(:user) }
  let(:question) { create(:question) }
  before do |test|
    unless test.metadata[:not_logged_in]
      login(user) #  controller_helper method
    end
  end

  describe 'GET #index', :not_logged_in do
    let(:questions) { create_list(:question, 3) } # FactoryBot implicates here
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show', :not_logged_in do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit,  params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end

  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to \
          change(Question, :count).by(1)
      end

      it 'redirects to <show>' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not \
          change(Question, :count)
      end

      it 're-renders <new>' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it ' assigns to be updated question to same @question (created by let())' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes a question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body'} }
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'redirects to an updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to assigns(question)
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'doesn\'t change a question' do
        question.reload

        expect(question.title).to eq 'BotTitle'
        expect(question.body).to eq 'BotQuestion'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    it 'deletes a question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to <index>' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
