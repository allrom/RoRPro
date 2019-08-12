require 'rails_helper'

feature 'User can sign-in', %q(
  In order to Ask questions
  As an Unauthenticated user
  I'd like to be able to Sign-in
) do
    given(:user) { create(:user) }

    scenario 'Registered user tries to sign in' do
      sign_in(user)
      ## save_and_open_page
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'Unregistered user tries to sign in' do
      visit new_user_session_path
      fill_in 'Email', with: 'nobody@test.edu'
      fill_in 'Password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end
end

