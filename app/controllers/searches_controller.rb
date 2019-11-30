class SearchesController < BaseController
  include UnauthIndex

  def index
    if search_params[:query] == ''
      flash.now[:error] = 'Empty search given'
    else
      @results = Services::Search.call(search_params)
    end
  end

  private

  def search_params
    params.permit(:query, :resource)
  end
end
