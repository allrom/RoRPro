class NotifyMailer < ApplicationMailer

  def question_update(user, answer)
    @question = answer.question
    @answer = answer
    @contributor = answer.user.email

    mail(to: user.email, subject: 'Question Update with new Answer')
  end
end
