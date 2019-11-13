class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    alias_action :update, :destroy, to: :modify

    return guest_permissions unless user
    user.admin? ? admin_permissions : user_permissions
  end

  def guest_permissions
    can :read, :all
  end

  def admin_permissions
    can :manage, :all
  end

  def user_permissions
    guest_permissions

    can :me, User, id: user.id

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :modify, [Question, Answer], user_id: user.id

    can :be_an_author, [Question, Answer] do |resource|
      user.author?(resource)
    end

    can :flag_best, Answer, question: { user_id: user.id }

    can [:upvote, :downvote], [Question, Answer] do |resource|
      next false if user.author?(resource)
      !resource.voted?(user)
    end

    can :dropvote, [Question, Answer] do |resource|
      !user.author?(resource)
    end

    can :destroy, Link, linkable: { user_id: user.id }

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
  end
end
