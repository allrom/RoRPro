class SubscriptionsController < BaseController

  authorize_resource

  def create
    question.subscribe(current_user)
    @subscription = question.subscriptions.find_by(user: current_user)
    flash.now[:notice] = 'Subscribed from now'
  end

  def destroy
    subscription.question.unsubscribe(current_user)
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
