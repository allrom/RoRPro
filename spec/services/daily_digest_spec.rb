require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let(:users) { create_list(:user, 2) }
  let(:questions_day_before) { create_list(:question, 2, :day_before, user: users.first) }

  it 'sends daily digest to all users if one-day questions present' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions_day_before).and_call_original }
    subject.send_digest
  end
end
