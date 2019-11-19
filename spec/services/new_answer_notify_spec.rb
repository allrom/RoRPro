require 'rails_helper'

RSpec.describe Services::NewAnswerNotify do
  let(:users_to_subscribe) { create_list(:user, 3 ) }
  let(:users_to_not_subscribe) { create_list(:user, 3 ) }

  let(:question) { create :question, user: users_to_subscribe.first }

  let(:updater) { create(:user) }
  let(:answer) { create :answer, question: question, user: updater }

  after { subject.send_update(answer) }

  it 'sends question update notification to author' do
    expect(NotifyMailer).to receive(:question_update).with(users_to_subscribe.first, answer).and_call_original
  end

  it 'sends question update notification to all that subscribed' do
    question.subscribe users_to_subscribe.second
    question.subscribe users_to_subscribe.third

    users_to_subscribe.each do |user|
      expect(NotifyMailer).to receive(:question_update).with(user, answer).and_call_original
    end
  end

  it 'does not send question update to answer author' do
    expect(NotifyMailer).to_not receive(:question_update).with(updater, answer).and_call_original
  end

  it 'does not send question update to those not subscribed' do
    users_to_not_subscribe.each do |user|
      expect(NotifyMailer).to_not receive(:question_update).with(user, answer).and_call_original
    end
  end
end
