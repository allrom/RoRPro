require 'rails_helper'

feature 'User can sign-in', %q(
  In order to Ask questions
  As an Unauthenticated user
  I'd like to be able to Sign-in
) do
    given(:user) { create(:user) }
    # Visit Login Page first (as devise did route)
    background { visit new_user_session_path }

    scenario 'Registered user tries to sign in' do
      # Type in e-mail(login)
      fill_in 'Email', with: user.email
      # Type in password
      fill_in 'Password', with: user.password
      # check out if login succeeded (devise reply)
      click_on 'Log in'
      # Open http page and see
      ## save_and_open_page
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'Unregistered user tries to sign in' do
      fill_in 'Email', with: 'nobody@test.edu'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
end

