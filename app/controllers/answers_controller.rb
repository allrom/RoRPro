class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show; end

  def new; end

  def edit; end

  def create
    # use build instead of new, so that 'build' creates new instance within AR assosiation (sets parent_id)
    @answer = question.answers.build(answer_params.merge(user: current_user))
    if answer.save
      flash.now[:notice] = "Answer added."
    else
      flash.now[:error] = "Answer not added."
      render :create
    end
  end

  def update
    if answer.update(answer_params)
      flash.now[:notice] = "Answer changed."
    else
      flash.now[:error] = "Answer not changed."
      render :update
    end
  end

  def destroy
    @question = answer.question
    answer.destroy
    flash.now[:notice] = "Answer removed."
  end

  def flag_best
    @question = answer.question
    answer.mark_best if question.user == current_user
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
