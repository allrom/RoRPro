require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_one(:award).dependent(:destroy) }

    include_examples 'model_associations'
  end

  describe 'validations' do
    it { should validate_presence_of :title}
    it { should validate_presence_of :body}
    it { should validate_length_of(:title).is_at_least(7) }
    it { should validate_length_of(:body).is_at_least(6) }
  end

  it { should have_db_index(:user_id) }

  include_examples 'files_as_attachments', Question

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :award }
end
