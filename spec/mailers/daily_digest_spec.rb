require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }

    let!(:questions_day_before) { create_list(:question, 2, :day_before, user: user) }
    let!(:questions_2days_before) { create_list(:question, 2, :two_days_before, user: user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Questions for a day")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders 'day before' questions" do
       questions_day_before.each do |question|
         expect(mail.body.encoded).to match question.title
       end
     end

    it "does not render 'two days before' questions" do
      questions_2days_before.each do |question|
        expect(mail.body.encoded).to_not match question.title
      end
    end
  end
end
