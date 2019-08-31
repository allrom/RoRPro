class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, presence: true, length: { minimum: 7 }
  validates :body, presence: true, length: { minimum: 6 }
end
