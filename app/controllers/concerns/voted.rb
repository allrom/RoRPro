module Voted
  extend ActiveSupport::Concern

  included do
    load_and_authorize_resource only: %i[upvote downvote dropvote]
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
    resource.dropvote(current_user)
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
end
