require 'rails_helper'

feature 'User can give an answer to a question', %q{
  In order to make Help to community
  As an Autheticated user
  I'd like to be able to Create answers
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:g_url) { 'https://google.com' }
  given(:ya_url) { 'http://ya.ru' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer-given', with: 'Answer with Some Text'
    end

    scenario 'gives an answer' do
      click_on 'Save'
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer added'

      within('.answer-list') do
        expect(page).to have_content 'Answer with Some Text'
      end
     end

    scenario 'gives an answer and attaches some files' do
      expect(current_path).to eq question_path(question)
      page.attach_file 'answer[files][]',
                      ["#{Rails.root}/spec/rails_helper.rb",  "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save'
      expect(page).to have_content 'Answer added'

      within('#answers-table') do
        click_on 'Files'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'gives an answer and binds some link(s)' do
      expect(current_path).to eq question_path(question)
      within('.give-answer') do
        click_on 'Add Link to Answer'
      end

      within all('.nested-fields')[0] do
        fill_in 'Link name', with: 'Some Link#1'
        fill_in 'Url', with: g_url
        ## -------------------------------------------------------------------------------
        ## This test runs OK in :selenium_chrome,  but FAILS with :selenium_chrome_headless  due to a bug:
        ## "https://makandracards.com/makandra/44054-bug-in-chrome-56+-prevents-filling-in-fields-with-slashes-using-selenium-webdriver-capybara"
        ##  forward slashes are ignored, see tmp/capybara/link_headless.png
        ## relative gems and chromium itself were updated, no go
        ## -------------------------------------------------------------------------------
      end
      click_on 'Save'
      page.save_screenshot 'link_chrome.png'

      expect(page).to have_content 'Answer added.'
      within('#answers-table') do
        click_on 'Links'
      end
      within('#links-binded') do
        expect(page).to have_link 'Some Link#1', href: g_url
      end
    end

    scenario 'composes a link with errors' do
      click_on 'Add Link to Answer'
      fill_in 'Link name', with: ''
      fill_in 'Url', with: 'http:///google.com'

      sleep(3)
      click_on 'Save'
      expect(page).to have_content 'Links name can\'t be blank'
      expect(page).to have_content 'Links url is not a valid URL'
    end

    scenario 'gives an answer with errors' do
      fill_in 'answer-given', with: ''
      click_on 'Save'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    expect(page).not_to have_field 'Give an Answer'
    expect(page).not_to have_selector(:link_or_button, 'OK')
  end

  context "multiple sessions" do
    scenario "the answer appears on other users page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer-given', with: 'Answer with Some Text'
        click_on 'Save'
        expect(page).to have_content 'Answer added'

        within('.answer-list') do
          expect(page).to have_content 'Answer with Some Text'
        end
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'Answer with Some Text'
      end
    end
  end
end
