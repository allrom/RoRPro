require 'rails_helper'

feature 'Edit own answer', %q{
  In order to update an answer
  As an answer Owner
  I'd like to be able to Edit an Answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:authors_answer) { create :answer, question: question, user: author }
  given!(:users_answer) { create :answer, question: question, user: user }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit questions_path
      click_on 'View'
      within "#answer_id-#{authors_answer.id}" do
        click_on 'Edit'
        ## close the 'within' scope to not raise "StaleElementReferenceError"
      end
    end

    scenario 'edits own answer' do
      fill_in 'answer-given', with: 'Updated Answer'
      click_on 'OK'
      expect(page).not_to have_content authors_answer.body
      expect(page).to have_content 'Updated Answer'
      expect(current_path).to eq edit_answer_path(authors_answer)
    end

    scenario 'edits own answer and attach some files' do
      page.attach_file 'answer[files][]',
                       ["#{Rails.root}/spec/rails_helper.rb",  "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'OK'
      click_on 'Back'
      within "#answer_id-#{authors_answer.id}" do
        click_on 'Files'
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'composes an answer with errors' do
      fill_in 'answer-given', with: ''
      click_on 'OK'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit users answer' do
      click_on 'Back'
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
