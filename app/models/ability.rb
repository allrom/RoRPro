class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_permissions : user_permissions
    else
      guest_permissions
    end
  end

  def guest_permissions
    can :read, :all
  end

  def admin_permissions
    can :manage, :all
  end

  def user_permissions
    guest_permissions

    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :flag_best, Answer, question: { user_id: user.id }

    can [:upvote, :downvote], [Question, Answer] do |resource|
      !(user.author?(resource) || resource.voted?(user))
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
