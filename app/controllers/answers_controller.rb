class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :author_check, only: %i[edit update destroy]

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(question), notice: "Answer added."
    else
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_path(id: answer.question_id), notice: "Answer changed."
    else
      @question = Question.find(answer.question_id)
      flash.now[:error] = "Answer not changed."
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question, notice: "Answer removed."
  end

  private

  def author_check
    if current_user != Answer.find(params[:id]).user
      redirect_to question_path(id: answer.question_id), notice: 'Not allowed.'
    end
  end

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
