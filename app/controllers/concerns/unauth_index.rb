module UnauthIndex
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: :index
  end
end


