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
  given(:g_url) { 'http://google.ru' }
  given(:ya_url) { 'http://ya.ru' }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit questions_path
      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on 'Edit'
      end
    end

    scenario 'edits own question' do
      fill_in 'Title', with: 'Updated Title'
      fill_in 'Body', with: 'Updated Question'
      click_on 'OK'
      click_on 'Dismiss'

      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on 'View'
      end
      visit current_path
      expect(page).not_to have_content authors_question.title
      expect(page).not_to have_content authors_question.body
      expect(page).to have_content 'Updated Title'
      expect(page).to have_content 'Updated Question'
      expect(current_path).to eq question_path(authors_question)
    end

    scenario 'edits own question and attach some files' do
      page.attach_file 'question[files][]',
                       ["#{Rails.root}/spec/rails_helper.rb",  "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'OK'
      expect(page).to have_content 'Question updated.'
      click_on 'Dismiss'

      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on 'View'
      end
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question and attach some link(s)' do
      click_on 'Add Link to Question'
      click_on 'Add Link to Question'

      within all('.nested-fields')[0] do
        fill_in 'Link name', with: 'Some Link#1'
        fill_in 'Url', with: g_url
      end
      within all('.nested-fields')[1] do
        fill_in 'Link name', with: 'Some Link#2'
        fill_in 'Url', with: ya_url
      end

      click_on 'OK'
      expect(page).to have_content 'Question updated.'
      click_on 'Dismiss'
      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on 'View'
      end

      within('#links-binded') do
        expect(page).to have_link 'Some Link#1', href: g_url
        expect(page).to have_link 'Some Link#2', href: ya_url
      end
    end

    scenario 'composes a link with errors' do
      click_on 'Add Link to Question'
      fill_in 'Link name', with: 'Some Link'
      click_on 'OK'
      expect(page).to have_content 'Links url is not a valid URL'
    end

    scenario 'composes a question with errors' do
      fill_in 'Title', with: ''
      fill_in 'Body', with: ''
      click_on 'OK'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to edit users question' do
      visit questions_path
      within "#question_id-#{users_question.id}" do
        expect(page).not_to have_link 'Edit'
      end
      expect(current_path).to eq questions_path
    end

    scenario 'tries to attach files to users question' do
      visit questions_path
      within('#questions-table') do
        find("#question_id-#{users_question.id}").click_on 'View'
      end
      expect(page).not_to have_field("input", type: 'file')
      expect(current_path).to eq question_path(users_question)
    end

    scenario 'tries to bind links to users question' do
      visit questions_path
      within('#questions-table') do
        find("#question_id-#{users_question.id}").click_on 'View'
      end
      expect(page).not_to have_link 'Add Link to Question'
      expect(current_path).to eq question_path(users_question)
    end
  end

  scenario 'Unauthenticated user tries to edit a question' do
    visit questions_path
    expect(page).not_to have_link 'Edit'
  end
end
