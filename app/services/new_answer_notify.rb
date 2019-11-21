class Services::NewAnswerNotify

  def send_update(answer)
    answer.question.subscribers.find_each do |user|
      next if user.author?(answer)
      NotifyMailer.question_update(user, answer).deliver_later
    end
  end
end
