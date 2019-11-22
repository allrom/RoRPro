require 'rails_helper'

RSpec.describe NotifyMailer, type: :mailer do
  describe 'question_update' do
    let(:user) { create(:user) }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: user }

    let(:mail) { NotifyMailer.question_update(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Question Update with new Answer')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders notification mail body' do
      expect(mail.body.encoded).to match question.title
      expect(mail.body.encoded).to match answer.body
      expect(mail.body.encoded).to match user.email
    end
  end
end
