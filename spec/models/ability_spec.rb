require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    # be_able_to  is a cancan rspec helper
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:visitor) { create(:user) }

    let(:question) { create :question, :with_attachment, user: user }
    let(:visitor_question) { create :question, :with_attachment, user: visitor }
    let(:answer) { create :answer, :with_attachment, question: question, user: user }
    let(:visitor_answer) { create :answer, :with_attachment, question: question, user: visitor }
    let(:user_answer) { create :answer, question: visitor_question, user: user }

    let(:upvoted_question) { create :question, :upvoted, user: user }
    let(:downvoted_question) { create :question, :downvoted, user: user }
    let(:upvoted_answer) { create :answer, :upvoted, user: user }
    let(:downvoted_answer) { create :answer, :downvoted, user: user }

    let(:link) { create :link, linkable: question }
    let(:visitor_link) { create :link, linkable: visitor_question }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'with controller' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, visitor_question }
      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, visitor_answer }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, visitor_question }
      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, visitor_answer }
    end

    context 'with flag best answer' do
      it { should be_able_to :flag_best, visitor_answer }
      it { should_not be_able_to :flag_best, user_answer }
    end

    context 'with answer voting' do
      it { should be_able_to :upvote, visitor_answer }
      it { should_not be_able_to :upvote, answer }

      it { should be_able_to :downvote, visitor_answer }
      it { should_not be_able_to :downvote, answer }

      it { should be_able_to :dropvote, visitor_answer }
      it { should_not be_able_to :dropvote, answer }

      it { should_not be_able_to :downvote, upvoted_answer }
      it { should_not be_able_to :upvote, downvoted_answer }
    end

    context 'with question voting' do
      it { should be_able_to :upvote, visitor_question }
      it { should_not be_able_to :upvote, question }

      it { should be_able_to :downvote, visitor_question }
      it { should_not be_able_to :downvote, question }

      it { should be_able_to :dropvote, visitor_question }
      it { should_not be_able_to :dropvote, question }

      it { should_not be_able_to :downvote, upvoted_question }
      it { should_not be_able_to :upvote, downvoted_question }
    end

    context 'with links' do
      it { should be_able_to :destroy, link }
      it { should_not be_able_to :destroy, visitor_link }
    end

    context 'with attachments' do
      it { should be_able_to :destroy, answer.files.first }
      it { should_not be_able_to :destroy, visitor_answer.files.first }
      it { should be_able_to :destroy, question.files.first }
      it { should_not be_able_to :destroy, visitor_question.files.first }
    end
  end
end
