require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:visitor) { create(:user) }
  let!(:question) { create :question, user: user }
  let!(:visitor_question) { create :question, user: visitor }

  let(:subscription) { question.subscriptions.first }
  let(:visitor_subscription) { visitor_question.subscriptions.first }

  before do |test|
    if test.metadata[:logged_in]
      login(user)
    end
  end

  describe 'POST #create' do
    subject(:create_request) { post :create, params: { question_id: visitor_question }, format: :js }

    context 'when user logged in', :logged_in do
      it 'saves a new record in database as question subscription' do
        expect { create_request }.to change(visitor_question.subscriptions, :count).by(1)
      end

      it 'saves a new record in database as user subscribed' do
        expect { create_request }.to change(visitor_question.subscribers, :count).by(1)
      end

      it { is_expected.to render_template :create }
    end

    context 'when not logged in' do
      it 'does not save a new record in subscriptions database' do
        expect { create_request }.to change(visitor_question.subscriptions, :count).by(0)
                                 .and change(visitor_question.subscribers, :count).by(0)
      end

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end

  describe 'DELETE #destroy' do
    subject(:destroy_request) { delete :destroy, params: { id: subscription }, format: :js }

    context 'when user logged in', :logged_in do
      it 'deletes a record in subscriptions database' do
        expect { destroy_request }.to change(question.subscriptions, :count).by(-1)
                                  .and change(question.subscribers, :count).by(-1)
      end

      it { is_expected.to render_template :destroy }

      context 'when user tries mistakenly unsubscribe' do
        it 'disallows a user to unsubscribe from visitor question, as one was not subscribed' do
          expect { delete :destroy, params: { id: visitor_subscription }, format: :js }
              .to_not change(visitor_question.subscribers, :count)
        end

        it { is_expected.to render_template :destroy }
      end
    end

    context 'when not logged in' do
      it 'does not save a new record in subscriptions database' do
        expect { destroy_request }.to change(question.subscriptions, :count).by(0)
                                  .and change(question.subscribers, :count).by(0)
      end

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end
