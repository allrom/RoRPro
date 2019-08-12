require 'rails_helper'

feature 'User can create an answer to a question', %q{
  In order to make Help to community
  As an Autheticated user
  I'd like to be able to Give an answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'gives an answer', js: true do
      click_on('Add Answer', match: :prefer_exact)
      ## save_and_open_page
      fill_in 'answer_given', with: 'Answer with Some Text'
      click_on 'OK'

      expect(page).to have_content 'Answer added'
      within '.give-answer' do
        expect(page).to have_content 'Answer with Some Text'
      end
    end

    scenario 'gives an answer with errors', js: true do
      click_on('Add Answer', match: :prefer_exact)
      click_on 'OK'

      expect(page).to have_content "Answers body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    expect(page).not_to have_selector(:link_or_button, 'Add Answer')
  end
end
