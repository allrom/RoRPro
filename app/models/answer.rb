class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user

  include Linkable
  include Attachable
  include Votable
  include Commentable

  validates :body, presence: true, length: { minimum: 2 }

  after_create :notify

  default_scope -> { order(best: :desc) }

  def mark_best
    # "transaction do.." multiple updates wrapped in one transaction, so one commit passed to db
    # AND a list of changes is applied either completely or not at all
    # "row lock" (mutex) ensures that a critical piece of code only runs in a SINGLE thread at the same time
    # "with_lock do.." does a transaction and a row-level lock (reloads record wit SQL "for update" clause. i.e.
    #  SELECT ... FOR UPDATE - grey color in console)
    with_lock do
      question.answers.where(best: true).update_all(best: false)
      # bang method inside transaction just ROLLS it BACK. "Update" silently leaves a record intact, if best: true
      self.update!(best: true)

      question.award.update!(user: user) if question.award
    end
  end

  private

  def notify
    NewAnswerJob.perform_later(self)
  end
end
