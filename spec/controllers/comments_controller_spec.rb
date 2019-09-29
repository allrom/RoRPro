require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:resource) { create :question, user: user }
  let(:comment_params) { {  question_id: resource, comment: attributes_for(:comment), commentable: 'question', format: :js } }

  before do |test|
    if test.metadata[:logged_in]
      login(user)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes', :logged_in do
      it 'saves a new comment in database' do
        expect { post :create, params: comment_params }.to change(resource.comments, :count).by(1)
      end

      it 'renders "create" template' do
        post :create, params: comment_params
        expect(response).to render_template :create
      end

      it 'binds created comment to the associated user' do
        expect { post :create, params: comment_params }.to change(user.comments, :count).by(1)
      end
    end

    context 'with invalid attributes', :logged_in do
      it 'doesn\'t save the comment' do
        expect { post :create, params: { question_id: resource, comment: attributes_for(:comment, :invalid), commentable: 'question', format: :js } }.to_not \
          change(Comment, :count)
      end

      it 'renders "create" template' do
        post :create, params: comment_params
        expect(response).to render_template :create
      end
    end

    context 'when not logged in' do
      it 'doesn\'t save a new comment in database' do
        expect { post :create, params: comment_params }.to_not change(Comment, :count)
        expect(response.status).to eq 401
      end
    end
  end
end
