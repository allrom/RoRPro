class Services::NewAnswerNotify

  def send_update(answer)
    answer.question.subscribers.find_each(batch_size: 100) do |user|
      NotifyMailer.question_update(user, answer)&.deliver_later unless user.author?(answer)
    end
  end
end
