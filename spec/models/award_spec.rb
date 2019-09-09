require 'rails_helper'

RSpec.describe Award, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).without_validating_presence }
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :image_filename }
  end

  describe 'idxs' do
    it { should have_db_index(:question_id) }
    it { should have_db_index(:user_id) }
  end
end
