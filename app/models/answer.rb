class Answer < ApplicationRecord
  belongs_to :question # ",required: true" by default in Rails 5,
                       # so no use to "validates :question_id, presence: true"

  validates :body, presence: true, length: { minimum: 2 }

  ## validates :question_id, presence: true
end
