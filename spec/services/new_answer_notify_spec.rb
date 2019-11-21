require 'rails_helper'

RSpec.describe Services::NewAnswerNotify do
  let(:users_to_subscribe) { create_list(:user, 2 ) }

  let(:author) { create(:user) }
  let(:question) { create :question, user: author }
  let(:answer) { create :answer, question: question, user: author }

  after(:each) do
    subject.send_update(answer)
  end

  it 'sends question update notification to all that subscribed' do
    users_to_subscribe.each { |user| question.subscribers << user }

    question.subscribers.without(author).each do |user|
      expect(NotifyMailer).to receive(:question_update).with(user, answer).and_call_original
    end
  end

  it 'does not send question update to answer author' do
    expect(NotifyMailer).to_not receive(:question_update).with(author, answer).and_call_original
  end
end
