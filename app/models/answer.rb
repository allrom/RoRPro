class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }

  default_scope -> { order(best: :desc) }

  def mark_best
    # multiple updates wrapped in one transaction, so one commit passed to db
    transaction do
      question.answers.where(best: true).update_all(best: false)
      self.toggle!(:best)
    end
  end
end
