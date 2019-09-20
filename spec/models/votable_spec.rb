require 'rails_helper'

describe 'votable' do
  with_model :WithVotable do
    table do |t|
      t.belongs_to :user
      t.timestamps null: false
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  with_model :Vote do
    table do |t|
      t.integer "number_of"
      t.belongs_to :user
      t.belongs_to :votable, polymorphic: true
      t.timestamps null: false
    end

    model do
      belongs_to :votable, polymorphic: true
      belongs_to :user
    end
  end

  let!(:user) { FactoryBot.create(:user) }
  let!(:visitor) { FactoryBot.create(:user) }
  let!(:resource) { WithVotable.create!(user: user) }

  describe '#upvote' do
    let(:vote_plus) { resource.vote(user, 1) }

    it 'creates new voted resorce' do
      expect{ vote_plus }.to change(resource.votes, :count).by(1)
    end

    it 'makes 1 vote up' do
     vote_plus
     expect(resource.votes.find_by(user: user).number_of).to eq 1
    end
  end

  describe '#downvote' do
    let(:vote_minus) { resource.vote(user, -1) }

    it 'creates new voted resorce' do
      expect{ vote_minus }.to change(resource.votes, :count).by(1)
    end

    it 'makes 1 vote down' do
      vote_minus
      expect(resource.votes.find_by(user: user).number_of).to eq -1
    end
  end

  describe '#dropvote' do
    before { resource.vote(user, 1) }

    it 'clears a vote on resource' do
      expect{ resource.dropvote(user) }.to change(resource.votes, :count).by(-1)
    end
  end

  describe '#amount' do
    before { resource.vote(user, 1) }

    it 'gives votes amount when visitor positive' do
      resource.vote(visitor, 1)
      expect(resource.amount).to eq 2
    end

    it 'gives votes amount when visitor negative' do
      resource.vote(visitor, -1)
      expect(resource.amount).to eq 0
    end
  end

  describe "#voted?" do
    before { resource.vote(user, 1) }

    it 'should assign user as a voter' do
      expect(resource).to be_voted(user)
    end
  end
end
