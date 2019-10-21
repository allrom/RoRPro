require 'rails_helper'

feature 'User can sign in Application with social provider account', %q{
  As a Registered user or a Visitor
  I'd like to be able to sign in Application
  with social provider account
} do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  describe 'social provider returns an email in its response' do
    scenario 'user can sign in with github account if providers response is correct' do
      expect(page).to have_content('Sign in with GitHub')
      mock_auth_hash('github')
      click_link 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from Github account')
      expect(page).to have_link 'Sign out'
     end

    scenario 'user can\'t sign in with github account if providers response is invalid' do
      expect(page).to have_content('Sign in with GitHub')
      invalid_mock_auth_hash('github')
      silence_omniauth { click_link 'Sign in with GitHub' }

      expect(page).to have_content "Could not authenticate you from GitHub because \"Invalid credentials\"."
      expect(page).to have_link 'Sign in'
      expect(page).to_not have_link 'Sign out'
    end
  end

  describe 'social provider does not return an email in its response' do
    scenario 'visitor can sign in with ones vkontakte account' do
      mock_auth_vkontakte
      silence_omniauth { click_link 'Sign in with Vkontakte' }
      expect(page).to have_content('Enter your e-mail for confirmation')

      fill_in 'e-mail', with: 'student@test.edu'
      click_on 'Send'

      expect(page).to have_content "Your e-mail confirmation has been sent"
      open_email 'student@test.edu'
      current_email.click_link 'Confirm my account'

      expect(page).to have_content "Your email address has been successfully confirmed"
      expect(page).to have_link 'Sign out'
    end

    scenario 'authorized user can sign in with ones vkontakte account' do
      auth = mock_auth_vkontakte
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      click_link 'Sign in with Vkontakte'

      expect(page).to have_content('Successfully authenticated from Vkontakte account')
      expect(page).to have_link 'Sign out'
    end
  end
end
