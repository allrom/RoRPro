require 'rails_helper'

feature 'Edit own question', %q{
  In order to update a question
  As an question Owner
  I'd like to be able to Edit a Question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:authors_question) { create :question, user: author }
  given!(:users_question) { create :question, user: user }

  describe 'Author' do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'edits own question' do
      within "#question_id-#{authors_question.id}" do
        click_on 'Edit'
        ## close the 'within' scope to not raise "StaleElementReferenceError"
      end
      fill_in 'Title', with: 'Updated Title'
      fill_in 'Body', with: 'Updated Question'
      click_on 'OK'

      within "#question_id-#{authors_question.id}" do
        click_on 'View'
      end
      visit current_path
      expect(page).not_to have_content authors_question.title
      expect(page).not_to have_content authors_question.body
      expect(page).to have_content 'Updated Title'
      expect(page).to have_content 'Updated Question'

      expect(current_path).to eq question_path(authors_question)
    end

    scenario 'composes a question with errors' do
      within "#question_id-#{authors_question.id}" do
        click_on 'Edit'
      end
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'OK'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit users question' do
      within "#question_id-#{users_question.id}" do
        expect(page).not_to have_link 'Edit'
      end
      expect(current_path).to eq questions_path
    end
  end

  scenario 'Unauthenticated user tries to edit a question' do
    visit questions_path
    expect(page).not_to have_link 'Edit'
  end
end
