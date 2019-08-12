class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :answers, allow_destroy: true

  validates :title, presence: true, length: { minimum: 7 }
  validates :body, presence: true, length: { minimum: 6 }
end
