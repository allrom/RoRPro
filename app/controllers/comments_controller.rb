class CommentsController < ApplicationController
  before_action :resource, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = resource.comments.build(comment_params)
    @comment.user = current_user
    if comment.save
      flash.now[:notice] = 'Your comment added.'
    else
      flash.now[:error] = "Comment not added."
      render :create
    end
  end

  private

  def resource
    resource_id_param = "#{params[:commentable]}_id"
    resource_klass = params[:commentable].classify.constantize
    resource_klass.find(params[resource_id_param])
  end

  def publish_comment
    return if comment.errors.any?
    # server broadcast path should match the route path
    ActionCable.server.broadcast "#{params[:commentable].pluralize}/#{resource.id}/comments",
                                 ApplicationController.renderer.render(
                                   partial: 'comments/comments_stream',
                                     locals: { comment: comment }
                                 )
  end

  helper_method  :comment, :resource

  def comment
    @comment ||= params[:id] ? Comment.find(params[:id]) : Comment.new
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
