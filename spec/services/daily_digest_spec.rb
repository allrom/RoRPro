require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let(:users) { create_list(:user, 2) }

  let(:questions_day_before) { create_list(:question, 2, :day_before, user: users.first) }
  let(:questions_2days_before) { create_list(:question, 2, :two_days_before, user: users.first) }

  after(:each) do
    subject.send_digest
  end

  it 'sends daily digest to all users if one-day questions present' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions_day_before).and_call_original }
  end

  it 'does not send daily digest to users if two-day questions present' do
    users.each { |user| expect(DailyDigestMailer).to_not receive(:digest).with(user, questions_2days_before).and_call_original }
  end
end
