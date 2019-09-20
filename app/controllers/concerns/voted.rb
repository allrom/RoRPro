module Voted
  extend ActiveSupport::Concern
  included do
    before_action :voter_check, only: %i[upvote downvote]
  end

  def upvote
    resource.vote(current_user, 1)
    respond
  end

  def downvote
    resource.vote(current_user, -1)
    respond
  end

  def dropvote
    resource.dropvote(current_user) if resource.voted?(current_user)
    respond
  end

  def respond
    respond_to do |format|
      format.json do
        render json: resource,
               methods: :amount,
               except: %i[created_at updated_at]
      end
    end
  end

  private

  def resource
    controller_name.classify.constantize.find(params[:id])
  end

  def voter_check
    if resource.user == current_user || resource.voted?(current_user)
      render plain: 'Vote is not allowed', status: :forbidden
    end
  end
end
