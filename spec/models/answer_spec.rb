require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should have_many(:links).dependent(:destroy) }
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
    it { should have_db_index(:best) }
  end

  describe '#mark_best' do
    let!(:user) { User.create(id: 1, email: 'test1@exanple.edu', password: '123456') }
    let!(:question) { user.questions.create(id: 1, title: 'TestTitle', body: 'TestBody') }
    let!(:answer_1) { user.answers.create(id: 1, question_id: 1, body: 'Test1') }
    let!(:answer_2) { user.answers.create(id: 2, question_id: 1, body: 'Test2') }
    let!(:answer_3) { user.answers.create(id: 3, question_id: 1, body: 'Test3', best: true) }

    it 'have many attached files as attachments' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end

    it { should accept_nested_attributes_for :links }

    context 'when answer get marked as "best"' do
      before  {
        answer_1.mark_best
        [answer_1, answer_2, answer_3].map(&:reload)
      }

      it 'should toggle ones answer "best" attribute -> true' do
        expect(answer_1).to be_best
      end

      it 'should toggle former answer "best" attribute -> false' do
        expect(answer_3).not_to be_best
      end

      it 'should leave other answers attribute -> false' do
        expect(answer_2).not_to be_best
      end
    end

    context 'when some action with model' do
      before {
        answer_2.mark_best
        [answer_1, answer_2, answer_3].map(&:reload)
      }
      it 'should be ordered by best answer being first' do
        expect(Answer.all).to eq [answer_2, answer_1, answer_3]
      end
    end
  end
end
