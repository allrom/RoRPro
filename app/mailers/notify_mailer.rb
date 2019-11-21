class NotifyMailer < ApplicationMailer

  def question_update(user, answer)
    @answer = answer

    mail(to: user.email, subject: 'Question Update with new Answer')
  end
end
