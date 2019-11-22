class SubscriptionsController < BaseController

  authorize_resource

  def create
    @subscription = question.subscriptions.create!(user: current_user)
    flash.now[:notice] = 'Subscribed from now'
  end

  def destroy
    @subscription.destroy if subscription.question.subscribed_by? current_user
    flash.now[:notice] = 'Successfully unsubscribed'
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  helper_method :subscription, :question
end
