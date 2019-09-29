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
  given(:g_url) { 'http://google.ru' }
  given(:ya_url) { 'http://ya.ru' }

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
      click_on 'Save'
      expect(page).not_to have_content authors_answer.body
      expect(page).to have_content 'Answer changed.'
      expect(current_path).to eq edit_answer_path(authors_answer)
    end

    scenario 'edits own answer and attaches some files' do
      page.attach_file 'answer[files][]',
                       ["#{Rails.root}/spec/rails_helper.rb",  "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'
      click_on 'Back'
      within "#answer_id-#{authors_answer.id}" do
        click_on 'Files'
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits own answer and binds some links' do
      within('.change-answer') do
        click_on 'Add Link to Answer'
        click_on 'Add Link to Answer'

        within all('.nested-fields')[0] do
          fill_in 'Link name', with: 'Some Link#1'
          fill_in 'Url', with: g_url
        end
        ## -----------------------------------------------------------------
        ## This test runs OK in :selenium_chrome_headless, with same setup
        ## -----------------------------------------------------------------
        within all('.nested-fields')[1] do
          fill_in 'Link name', with: 'Some Link#2'
          fill_in 'Url', with: ya_url
        end
      end
      click_on 'Save'

      expect(page).to have_content 'Answer changed.'
      click_on 'Back'
      within('#answers-table') do
        click_on 'Links'
      end

      within('#links-binded') do
        expect(page).to have_link 'Some Link#1', href: g_url
        expect(page).to have_link 'Some Link#2', href: ya_url
      end
    end

    scenario 'composes a link with errors' do
      within('.change-answer') do
        click_on 'Add Link to Answer'
        fill_in 'Link name', with: ''
        fill_in 'Url', with: 'http:///google.com'
      end
      click_on 'Save'

      expect(page).to have_content 'Links name can\'t be blank'
      expect(page).to have_content 'Links url is not a valid URL'
    end

    scenario 'composes an answer with errors' do
      fill_in 'answer-given', with: ''
      click_on 'Save'
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
