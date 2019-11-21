require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :body}
    it { should validate_length_of(:body).is_at_least(2) }
  end

  include_examples 'files_as_attachments'

  it { should accept_nested_attributes_for :links }

  describe 'idxs' do
    it { should have_db_index(:question_id) }
    it { should have_db_index(:user_id) }
    it { should have_db_index(:best) }
  end

  describe '#mark_best' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:question) { FactoryBot.create(:question, user: user) }
    let!(:award) { FactoryBot.create(:award, question: question, name: 'TestAward') }

    let!(:answer_1) { FactoryBot.create(:answer, question: question, user: user, body: 'Test1') }
    let!(:answer_2) { FactoryBot.create(:answer, question: question, user: user, body: 'Test2') }
    let!(:answer_3) { FactoryBot.create(:answer, question: question, user: user, body: 'Test3', best: true) }

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

      it 'should pass an award to the user' do
        expect(user.awards).to include(award)
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
