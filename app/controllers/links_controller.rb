class LinksController < BaseController

 load_and_authorize_resource

 def destroy
   @link = Link.find(params[:id])
   @link.destroy!
   flash.now[:notice] = "Link removed."
 end
end
