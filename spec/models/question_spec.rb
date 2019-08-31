require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :title}
    it { should validate_presence_of :body}
    it { should validate_length_of(:title).is_at_least(7) }
    it { should validate_length_of(:body).is_at_least(6) }
  end

  it { should have_db_index(:user_id) }

  it 'have many attached attachments' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
