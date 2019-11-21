class DailyDigestMailer < ApplicationMailer

  def digest(user, questions)
    @questions = questions

    mail(to: user.email, subject: 'Questions for a day')
  end
end
