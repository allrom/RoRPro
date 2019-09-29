class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :gon_set_user, unless: :devise_controller?

  private

  def gon_set_user
    gon.user_id = current_user.id if current_user
    gon.ami_signed_in = user_signed_in?
  end
end
