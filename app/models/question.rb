class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  has_one :award, dependent: :destroy
  belongs_to :user

  include Linkable
  include Attachable
  include Votable
  include Commentable

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, presence: true, length: { minimum: 7 }
  validates :body, presence: true, length: { minimum: 6 }

  after_create :subscribe_author, :calculate_reputation

  def subscribed_by?(user)
    subscribers.include?(user)
  end

  private

  def subscribe_author
    subscribers << user
  end

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end

