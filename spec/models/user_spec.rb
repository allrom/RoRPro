require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email}
    it { should validate_presence_of :password }
  end

  describe '#author?' do
    subject { user.author?(@object) }

    let(:owner) { User.new(id: 1, email: 'test1@exanple.edu') }
    let(:visitor) { User.new(id: 2, email: 'test2@exanple.edu') }
    let(:owners_question) { owner.questions.new(id: 1, title: 'TestTitle', body: 'TestBody') }
    let(:owners_answer) { owner.answers.new(id: 1, question_id: 1, body: 'Test') }

    before do  |test|
      if test.metadata[:question]
        @object = owners_question
      end
      if test.metadata[:answer]
        @object = owners_answer
      end
    end

    context 'if user is author'  do
      let(:user) { owner }
      it 'should return "true" for question', :question do
        expect(subject).to eq(true)
      end

      it 'should return "true" for answer', :answer do
        expect(subject).to eq(true)
      end
    end

    context 'if not author'  do
      let(:user) { visitor }
      it 'should return "false" for question', :question do
        expect(subject).to eq(false)
      end

      it 'should return "false" for answer', :answer do
        expect(subject).to eq(false)
      end
    end
  end
end
