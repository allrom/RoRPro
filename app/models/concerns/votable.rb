module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def vote(user, value)
    vote = votes.where(user: user).first_or_initialize
    with_lock do
      vote.number_of = value
      vote.save!
    end
  end

  def dropvote(user)
    votes.where(user: user).destroy_all
  end

  def voted?(user)
    votes.exists?(user: user)
  end

  def amount
    votes.sum :number_of
  end
end
