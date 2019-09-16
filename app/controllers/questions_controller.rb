class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    questions
  end

  def create
    @question = current_user.questions.build(question_params)
    if question.save
      flash.now[:notice] = 'Your question created.'
    else
      flash.now[:error] = "Question not added."
      render :create
    end
  end

  def show; end

  def new
    question.build_award
  end

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
    # load attachments in a batch (n+1 query problem)
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def questions
    @questions = Question.all
  end

  def answer
    @answer = question.answers.build
  end

  helper_method :question, :questions, :answer

  def question_params
    params.require(:question).permit(
        :title,
        :body,
        files: [],
        links_attributes: [:name, :url, :_destroy],
        award_attributes: [:name, :image]
    )
  end
end
