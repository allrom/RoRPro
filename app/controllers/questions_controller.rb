class QuestionsController < ApplicationController
  after_action :publish_question, only: :create

  include UnauthIndex
  include UnauthShow
  include Voted

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

  def show
    gon.question_id = params[:id]
  end

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

  def publish_question
    return if question.errors.any?

    ActionCable.server.broadcast "questions",
                                 ApplicationController.renderer.render(
                                   partial: 'questions/questions_stream',
                                     locals: { question: question }
                                 )
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def questions
    @questions = Question.all
  end

  def answer
    @answer = question.answers.build
  end

  def comment
    question.comments.build
  end

  helper_method :question, :questions, :answer, :comment

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
