class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @questions = Question.all
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was created.'
    else
      render :new
    end
  end

  def show; end

  def new; end

  def edit; end

  def update
    if question.update(question_params)
      redirect_to question,  notice: 'Question updated.'
    else
      render :edit
    end

    question_params[:answers_attributes]&.values&.each do |attr|
     flash[:warning] = 'Answer removed.' if attr[:_destroy] == '1'
     flash[:warning] = 'Answer added.' if attr[:id].blank?
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

  helper_method :question # to make it avail for views, like instance vars

  def question_params
    params.require(:question).permit(:title, :body, answers_attributes: %i[ id body _destroy ])

    ## params.require(:question)
    ##       .permit(:title, :body, answers_attributes: %i[ id body _destroy ])
    ##      .to_h.deep_merge(answers_attributes: [ user_id: current_user.id ])

    ## work_params = params.require(:question).permit(:title, :body, answers_attributes: %i[ id body _destroy ])
    ## add_params = { user_id: current_user.id, answers_attributes: [ user_id: current_user.id ] }
    ## result_params = work_params.merge(add_params) do |_key, curr_val, new_val|
    ##  curr_val ||= {}
    ##  curr_val.merge(new_val)
    ## end
    ## result_params.permit!
  end
end
