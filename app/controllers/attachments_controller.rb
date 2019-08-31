class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    file.purge
    flash.now[:notice] = "File removed."
  end

  private

  def file
    @file
  end

  helper_method :file
end
