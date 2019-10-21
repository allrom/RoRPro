class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_with_provider, only: %i[vkontakte github]

  def vkontakte; end

  def github;  end

  private

  def sign_with_provider
    auth = request.env['omniauth.auth']
    unless auth
      redirect_to new_user_session_path, alert: 'No authentication data'
      return
    end

    if user&.confirmed?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:notice] = 'Your e-mail address is required to proceed sign up'

      session[:oauth_provider] = auth.provider
      session[:oauth_uid] = auth.uid
      redirect_to new_user_confirmation_path
    end
  end

  def user
    @user = User.find_for_oauth(request.env['omniauth.auth'])
  end
end
