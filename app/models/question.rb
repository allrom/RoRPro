class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { minimum: 10 }
  validates :body, presence: true, length: { minimum: 8 }
end
