class Services::DailyDigest

  def send_digest
    # ActiveJob cannot serialize 'collection', so '.to_a' conversion is added
    # to stop serialization log errors and for test correctness
    questions = Question.where(created_at: 1.day.ago.all_day).to_a
    return if questions.empty?

    User.find_each do |user|
      DailyDigestMailer.digest(user, questions).deliver_later
    end
  end
end
