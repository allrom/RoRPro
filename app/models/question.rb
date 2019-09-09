class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :award, dependent: :destroy

  belongs_to :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, presence: true, length: { minimum: 7 }
  validates :body, presence: true, length: { minimum: 6 }
end
