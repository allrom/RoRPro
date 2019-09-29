class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy
  belongs_to :user

  include Linkable
  include Attachable
  include Votable
  include Commentable

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, presence: true, length: { minimum: 7 }
  validates :body, presence: true, length: { minimum: 6 }
end
