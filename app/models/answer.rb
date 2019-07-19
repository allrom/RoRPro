class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true, length: { minimum: 2 }
  validates :question_id, presence: true
end


