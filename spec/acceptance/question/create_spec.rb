require 'rails_helper'

feature 'User can create a question', %q{
  In order to get Answer from community
  As an Autheticated user
  I'd like to be able to Ask a Question
} do
  given(:user) { create(:user) }
  describe 'Authenticated user', js: true do

    background do
      sign_in(user) #  feature_helper method
      visit questions_path
      click_on 'Ask a question'
      fill_in 'Title', with: 'Some Title'
      fill_in 'Body', with: 'Question with Some Text'
    end

    scenario 'asks a question' do
      click_on 'OK'
      expect(page).to have_content 'Your question created.'
      click_on 'View'
      expect(page).to have_content 'Some Title'
      expect(page).to have_content 'Question with Some Text'
    end

    scenario 'asks a question and attach some files' do
      page.attach_file 'question[files][]',
                       ["#{Rails.root}/spec/rails_helper.rb",  "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'OK'
      expect(page).to have_content 'Your question created.'
      click_on 'View'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'OK'
      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask a question'
    expect(current_path).to eq new_user_session_path
    visit new_question_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
