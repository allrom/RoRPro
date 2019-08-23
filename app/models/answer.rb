class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }

  default_scope -> { order(best: :desc) }

  def mark_best
    Answer.where(question_id: question_id, best: true).update_all(best: false)
    self.toggle(:best).save
  end
end
