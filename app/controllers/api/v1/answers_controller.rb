class Api::V1::AnswersController < Api::V1::BaseController
  # CanCanCan is unable to authorize w/o explicit var preload
  load_and_authorize_resource except: :show

  def show
    render json: answer
  end

  def create
    @answer = question.answers.build(answer_params.merge(user: current_resource_owner))
    if answer.save
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if answer.update(answer_params)
      render json: answer, status: :created
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if answer.destroy
      render json: {}, status: :ok
    else
      render json: { errors: answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
