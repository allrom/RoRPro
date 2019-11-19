require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    include_examples 'question_association'
    include_examples 'user_association'
  end

  describe 'indexation' do
    it { should have_db_index(:question_id) }
    it { should have_db_index(:user_id) }
  end

  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }
    subject { Subscription.new(user: user) }

    it { should validate_presence_of :user}
    it { should validate_presence_of :question}

    it { should validate_uniqueness_of(:user_id).scoped_to(:question_id).case_insensitive }
  end
end
