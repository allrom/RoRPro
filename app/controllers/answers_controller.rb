class AnswersController < BaseController
  after_action :publish_answer, only: :create
  before_action :answer, only: :flag_best

  include UnauthShow
  include UnauthLinks
  include Voted

  authorize_resource
  skip_authorize_resource only: :links

  def show; end

  def links
    @answer = Answer.find(params[:answer_id])
    @question = Question.find(@answer.question_id)
  end

  def new; end

  def edit; end

  def create
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
    @answer.mark_best
  end

  private

  def publish_answer
    return if answer.errors.any?

    ActionCable.server.broadcast "questions/#{answer.question_id}/answers",
                                 ApplicationController.renderer.render(
                                   partial: 'answers/answers_stream',
                                    locals: { answer: answer }
                                 )
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new
  end

  def award
    answer.question.award
  end

  def comment
    answer.comments.build
  end

  helper_method :answer, :question, :comment

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end
end
