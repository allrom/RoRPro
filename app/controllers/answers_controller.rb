class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.create(answer_params.merge(user: current_user))
    flash.now[:notice] = "Answer added."
  end

  def update
    if answer.update(answer_params)
      flash.now[:notice] = "Answer changed."
    else
      flash.now[:notice] = "Answer not changed."
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
