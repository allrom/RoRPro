require 'rails_helper'

feature 'User can sign-out', %q{
  In order to Gracefully Quit
  As an Authenticated user
  I'd like to be able to Sign-out
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)
    visit questions_path

    expect(page).to have_link 'Sign out'
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries to sign out' do
    visit questions_path
    expect(page).not_to have_link 'Sign out'
    expect(page).to have_link 'Sign in'
  end
end

