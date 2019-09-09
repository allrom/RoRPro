class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    if current_user.author?(resource)
      link.destroy!
      flash.now[:notice] = "Link removed."
    end
  end

  private

  def resource
    link.linkable
  end

  def link
    @link
  end

  helper_method :link
end
