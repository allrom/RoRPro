require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_one(:award).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should belong_to(:user) }

    it { should have_many(:subscriptions).dependent(:destroy) }
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

  describe '#subscribed_by?' do
    let(:user) { FactoryBot.create(:user) }
    let(:visitor) { FactoryBot.create(:user) }
    let(:question) { FactoryBot.create(:question, user: user) }

    it 'should return "true" for user as subscriber' do
      expect(question).to be_subscribed_by(user)
    end

    it 'should return "false" for visitor as subscriber' do
      expect(question).to_not be_subscribed_by(visitor)
    end
  end

  describe 'reputation' do
    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(subject)
      subject.save!
    end
  end

  describe 'subscription' do
    it 'auto subscribes the author' do
      expect(subject).to receive(:subscribe_author)
      subject.save!
    end
  end
end
