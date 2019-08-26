require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  before do |test|
    if test.metadata[:logged_in]
      login(user) #  controller_helper method
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) } # FactoryBot implicates here
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    ## prevents 'InvalidCrossOriginRequest' error
    before { get :new, xhr: true }

    it 'renders new view', :logged_in do
      expect(response).to render_template :new
    end

    it 'redirects to login if unauthorized' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET #edit' do
    before { get :edit,  params: { id: question } }

    it 'renders edit view', :logged_in do
      expect(response).to render_template :edit
    end

    it 'redirects to login if unauthorized' do
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes', :logged_in do
      it 'saves a new question in database' do
        expect { post :create, params: { question: attributes_for(:question) }, format: :js }.to \
          change(Question, :count).by(1)
      end

      it 'processes js to create new question' do
        post :create, params: { question: attributes_for(:question), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes', :logged_in do
      it 'doesn\'t save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) }, format: :js }.to_not \
          change(Question, :count)
      end

      it 'renders "create" template' do
        post :create, params: { question: attributes_for(:question, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not \
          change(Question, :count)
        expect(response).to redirect_to(new_user_session_path)
       end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes', :logged_in do
      it ' assigns to be updated question to same @question (created by let())' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes a question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body'}, format: :js }
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'renders "update" template' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes', :logged_in do
      before {
        patch :update,
              params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'doesn\'t change a question' do
        question.reload

        expect(question.title).not_to eq nil
        expect(question.body).to eq 'BotQuestion'
      end

      it 're-renders "update" view' do
        expect(response).to render_template :update
      end
    end

    context 'when not logged in' do
      before { patch :update, params: { id: question, question: attributes_for(:question) } }
      it 'redirects to login if unauthorized' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'when logged in', :logged_in do
      it 'deletes a question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to <index>' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'when not logged in' do
      it 'redirects to login if unauthorized' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
