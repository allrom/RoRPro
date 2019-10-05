require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:awards).dependent(:destroy) }

    include_examples 'comments_association'
  end

  describe 'validations' do
    it { should validate_presence_of :email}
    it { should validate_presence_of :password }
  end

  describe '#author?' do
    let(:owner) { User.new(id: 1, email: 'test1@exanple.edu') }
    let(:visitor) { User.new(id: 2, email: 'test2@exanple.edu') }
    let(:owners_question) { owner.questions.new(id: 1, title: 'TestTitle', body: 'TestBody') }
    let(:owners_answer) { owner.answers.new(id: 1, question_id: 1, body: 'Test') }

    context 'if user is author'  do
      it 'should return "true" for question' do
        expect(owner).to be_author(owners_question)
      end

      it 'should return "true" for answer' do
        expect(owner).to be_author(owners_answer)
      end
    end

    context 'if not author'  do
      it 'should return "false" for question' do
        expect(visitor).not_to be_author(owners_question)
      end

      it 'should return "false" for answer' do
        expect(visitor).not_to be_author(owners_answer)
      end
    end
  end
end
