class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

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
    end
  end
end
