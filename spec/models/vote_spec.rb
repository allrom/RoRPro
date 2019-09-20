require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:votable) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { FactoryBot.create(:user) }
    subject { Vote.new(user: user)}
    it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]).case_insensitive }

    it { should validate_inclusion_of(:number_of).in_array([-1, 1]) }
  end
end
