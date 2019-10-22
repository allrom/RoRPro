class OauthConfirmationsController < Devise::ConfirmationsController
  def create
    password = Devise.friendly_token[0, 20]
    @user = User.new(email: params[:email], password: password, password_confirmation: password)

    if @user.save
      @user.send_confirmation_instructions
    else
      flash.now[:alert] = 'Entered e-mail is invalid'
      render :new
    end
  end

  protected

  def after_confirmation_path_for(resource_name, user)
    # overrides devise protected method to create authorization after if no email in providers response
    auth = { provider: session[:oauth_provider], uid: session[:oauth_uid] }

    user.authorizations.create(auth) if auth.values.all?
    sign_in user, event: :authentication
    signed_in_root_path(user)
  end
end
