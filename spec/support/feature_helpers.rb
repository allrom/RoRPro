module FeatureHelpers
  def sign_in(user)
    # Visit Login Page first (as devise did routes)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    # check out if login succeeded (devise reply)
    click_on 'Log in'
  end
end
