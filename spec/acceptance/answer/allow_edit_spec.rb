require 'rails_helper'

feature 'Edit own answer', %q{
  In order to update an answer
  As an question Owner
  I'd like to be able to Edit a Question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:authors_answer) { create :answer, question: question, user: author }
  given!(:users_answer) { create :answer, question: question, user: user }

  describe 'Author' do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'edits own answer' do
      click_on 'View'
      within "#answer_id-#{authors_answer.id}" do
        click_on 'Edit'
      end
      fill_in 'answer-given', with: 'Updated Answer'
      click_on 'OK'
      expect(page).to have_content 'Updated Answer'
      expect(page).not_to have_content authors_answer.body
      expect(current_path).to eq question_path(question)
    end

    scenario 'composes an answer with errors' do
      click_on 'View'
      within "#answer_id-#{authors_answer.id}" do
        click_on 'Edit'
      end
      fill_in 'answer-given', with: ''
      click_on 'OK'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit users answer' do
      click_on 'View'
      within "#answer_id-#{users_answer.id}" do
        expect(page).not_to have_link 'Edit'
      end
      expect(current_path).to eq question_path(question)
    end
   end

  scenario 'Unauthenticated user tries to edit an answer' do
    visit questions_path
    expect(page).not_to have_link 'Edit'
  end
end
