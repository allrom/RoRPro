class Services::DailyDigest

  def send_digest
    questions = Question.where(created_at: 1.day.ago.all_day).to_a

    if questions.present?
      User.find_each do |user|
        DailyDigestMailer.digest(user, questions).deliver_later
      end
    end
  end
end
