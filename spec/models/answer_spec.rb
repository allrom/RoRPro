require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :body}
    it { should validate_length_of(:body).is_at_least(2) }
  end

  describe 'idxs' do
    it { should have_db_index(:question_id) }
    it { should have_db_index(:user_id) }
   end
end
