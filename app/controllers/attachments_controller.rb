class AttachmentsController < BaseController
  load_and_authorize_resource class: ActiveStorage::Attachment

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
