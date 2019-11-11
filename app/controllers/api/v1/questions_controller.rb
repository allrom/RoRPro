class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource except: %i[index show]

  def index
    render json: questions
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.questions.build(question_params)
    if question.save
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      render json: question, status: :created
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if question.destroy
      render json: {}, status: :ok
    else
      render json: { errors: question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  # http://localhost:3000/api/v1/questions.json?access_token=4354535c34f45.......
  def questions
    @questions ||= Question.all.with_attached_files
  end

  def question_params
    params.require(:question).permit(
        :title,
        :body,
        files: [],
        links_attributes: [:name, :url, :_destroy]
    )
  end
end
