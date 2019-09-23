class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true, uniqueness: { scope: %i[votable_id votable_type] }
  validates :number_of, inclusion: { in: [1, -1], allow_nil: true }
end
