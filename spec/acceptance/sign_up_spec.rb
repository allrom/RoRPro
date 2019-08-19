require 'rails_helper'

feature 'User can sign-up', %q{
  In order to be able to Ask a question
  As a Registered user
  I'd like to be able to Sign-up
} do
  given(:user) { create(:user) }

  scenario 'Unregistered user tries to sign up' do
    visit questions_path
    click_on 'Sign up'

    fill_in 'Email', with: 'new_person@test.edu'
    fill_in 'Password', with: '87654321'
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Register'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Registered user tries to sign up' do
    visit questions_path
    click_on 'Sign up'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Register'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq user_registration_path
  end
end
