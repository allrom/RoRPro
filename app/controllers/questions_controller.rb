class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :author_check, only: %i[edit update destroy]

  def index
    @questions = Question.all
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to questions_path, notice: 'Your question was created.'
    else
      render :new
    end
  end

  def show; end

  def new; end

  def edit; end

  def update
    if question.update(question_params)
      redirect_to questions_path, notice: 'Question updated.'
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Question removed.'
  end

  private

  def author_check
    if current_user != Question.find(params[:id]).user
      redirect_to questions_path, notice: 'Not allowed.'
     end
  end

  def question # callback replacement
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def answer
    @answer = question.answers.build
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
