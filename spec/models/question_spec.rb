require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_one(:award).dependent(:destroy) }

    include_examples 'links_association'
    include_examples 'votes_association'
    include_examples 'comments_association'
    include_examples 'user_association'
    include_examples 'subscriptions_association'

    it { should have_many(:subscribers).through(:subscriptions).source(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :title}
    it { should validate_presence_of :body}
    it { should validate_length_of(:title).is_at_least(7) }
    it { should validate_length_of(:body).is_at_least(6) }
  end

  it { should have_db_index(:user_id) }

  include_examples 'files_as_attachments'

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }

  describe 'reputation' do
    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(subject)
      subject.save!
    end
  end

  context 'manage subscriptions' do
    let(:user) { create(:user) }
    let(:user_question) { create :question, user: user }
    let(:visitor_question) { create(:question) }

    describe 'when #subscribe_author' do
       it 'auto subscribes the author' do
         expect(subject).to receive(:subscribe).with(subject.user)
         subject.save!
       end
     end

    describe 'when #subscribe' do
      it 'subscribes the user' do
        expect { visitor_question.subscribe(user) }.to change(visitor_question.subscribers, :count).by(1)
      end

      it 'does not subscribe user if already subscribed' do
        expect { user_question.subscribe(user) }.to_not change(user_question.subscribers, :count)
      end
    end

    describe 'when #unsubscribe' do
      it 'unsubscribes the user' do
        expect { user_question.unsubscribe(user) }.to change(user_question.subscribers, :count).by(-1)
      end

      it 'does not unsubscribe user if was not subscribed' do
        expect { visitor_question.unsubscribe(user) }.to_not change(visitor_question.subscribers, :count)
      end
    end
  end
end
