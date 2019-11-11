class BaseController < ApplicationController
  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :gon_set_user, unless: :devise_controller?

  check_authorization unless :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      # routes can be discovered over "curl" without signed in, so
      # secure approach is to return 404 (not found) or 403 (forbidden)
      # instead of 302 (found but not permitted)

      format.html { redirect_to root_url, alert: exception.message, status: :forbidden }
      format.js { render 'shared/exception', locals: { message: exception.message }, status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
     end
  end

  private

  def gon_set_user
    gon.user_id = current_user.id if current_user
  end


end
