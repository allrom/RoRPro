class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    questions
  end

  def create
    @question = current_user.questions.create(question_params)
    flash.now[:notice] = 'Your question was created.'
  end

  def show; end

  def new; end

  def edit; end

  def update
    if question.update(question_params)
      flash.now[:notice] = 'Question updated.'
    else
      flash.now[:notice] = "Answer not changed."
      render :update
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Question removed.'
  end

  private

  def question # callback replacement
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def questions
    @questions = Question.all
  end

  def answer
    @answer = question.answers.build
  end

  helper_method :question, :questions, :answer

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
