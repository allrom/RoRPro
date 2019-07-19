require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
  end

  describe 'validations' do
    it { should validate_presence_of :body}
    it { should validate_length_of(:body).is_at_least(2) }
  end

  it { should have_db_index(:question_id) }
end
