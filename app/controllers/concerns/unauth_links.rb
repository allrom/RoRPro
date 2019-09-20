module UnauthLinks
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: :links
  end

end


