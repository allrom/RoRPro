class AttachmentsController < ApplicationController

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if current_user.author?(resource)
      file.purge
      flash.now[:notice] = "File removed."
    end
  end

  private

  def resource
    file.record_type.constantize.find(file.record_id)
  end

  def file
    @file
  end

  helper_method :file
end
