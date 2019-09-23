require 'rails_helper'

RSpec.shared_examples "voted" do
  before do |test|
    if test.metadata[:logged_in]
      login(user) #  controller_helper method
    end
  end

  describe 'PATCH #upvote' do
    it 'upvotes the resource', :logged_in do
      expect{ patch :upvote, params: visitor_params }.to change(visitor_resource.votes, :count).by(1)
    end

    it 'changes the number of votes', :logged_in do
      patch :upvote, params: visitor_params
      expect(visitor_resource.votes.first.number_of).to eq 1
    end

    it 'blocks double votes', :logged_in do
      patch :upvote, params: visitor_params
      patch :downvote, params: visitor_params
      expect(visitor_resource.votes.first.number_of).to eq 1
    end

    it 'renders votable resource as json', :logged_in do
      patch :upvote, params: visitor_params
      expect(response).to be_successful
    end

    context 'when author tries to vote' do
      it 'blocks author from self votes', :logged_in do
        expect{ patch :upvote, params: params }.not_to change(resource.votes, :count)
      end

      it 'renders status "forbidden"', :logged_in do
        patch :upvote, params: params
        ## is_expected.to respond_with 403
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when guest tries to vote' do
      it 'disallows guests to vote' do
        expect{ patch :upvote, params: visitor_params }.not_to change(visitor_resource.votes, :count)
      end

      it 'renders status "not authorized"' do
        patch :upvote, params: visitor_params
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #downvote' do
    it 'downvotes the resource', :logged_in do
      expect{ patch :downvote, params: visitor_params }.to change(visitor_resource.votes, :count).by(1)
    end

    it 'changes the number of votes', :logged_in do
      patch :downvote, params: visitor_params
      expect(visitor_resource.votes.first.number_of).to eq -1
    end

    it 'blocks double votes', :logged_in do
      patch :downvote, params: visitor_params
      patch :upvote, params: visitor_params
      expect(visitor_resource.votes.first.number_of).to eq -1
    end

    it 'renders votable resource as json', :logged_in do
      patch :downvote, params: visitor_params
      expect(response).to be_successful
    end

    context 'when author tries to vote' do
      it 'blocks author from self votes', :logged_in do
        expect{ patch :downvote, params: params }.not_to change(resource.votes, :count)
      end

      it 'renders status "forbidden"', :logged_in do
        patch :downvote, params: params
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when guest tries to vote' do
      it 'disallows guests to vote' do
        expect{ patch :downvote, params: visitor_params }.not_to change(visitor_resource.votes, :count)
      end

      it 'renders status "not authorized"' do
        patch :downvote, params: visitor_params
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #dropvote' do
    before { patch :upvote, params: visitor_params }

    it 'drops all votes on resource', :logged_in do
      expect{ patch :dropvote, params: visitor_params }.to change(visitor_resource.votes, :count).by(-1)
    end

    it 'renders votable resource as json', :logged_in do
      patch :dropvote, params: visitor_params
      expect(response).to be_successful
    end

    context 'when author tries to drop votes' do
      before { patch :upvote, params: params }

      it 'blocks author from clear\' own resource', :logged_in do
        expect{ patch :dropvote, params: params }.not_to change(resource.votes, :count)
      end
    end

    context 'when guest tries to clear votes' do
      it 'disallows guests to drop votes' do
        expect{ patch :dropvote, params: visitor_params }.not_to change(visitor_resource.votes, :count)
      end

      it 'renders status "not authorized"' do
        patch :dropvote, params: visitor_params
        expect(response).to be_unauthorized
      end
    end
  end
end
