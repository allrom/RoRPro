require 'rails_helper'

feature 'User can create a question', %q{
  In order to get Answer from community
  As an Autheticated user
  I'd like to be able to Ask a Question
} do
  given(:user) { create(:user) }
  given(:g_url) { 'https://google.com' }
  given(:ya_url) { 'http://ya.ru' }

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
      expect(page).to have_content 'Your question created.'
      click_on 'View'

      within('#links-binded') do
        expect(page).to have_link 'Some Link#1', href: g_url
        expect(page).to have_link 'Some Link#2', href: ya_url
      end
    end

    scenario 'asks a question and create some reward' do
      within('.nested-award') do
        fill_in 'award-given', with: 'One Star Reward'
        page.attach_file "#{Rails.root}/app/assets/images/one_star.png"
      end
        click_on 'OK'
        expect(page).to have_content 'Your question created.'

        click_on 'View'
      within('.award-info') do
        expect(page).to have_content "* This Question contains One Star Reward Award"
      end
    end

    scenario 'composes an award with errors' do
      within('.nested-award') do
        fill_in 'award-given', with: ''
        page.attach_file "#{Rails.root}/app/assets/images/one_star.png"
      end
      click_on 'OK'
      expect(page).to have_content 'Award name can\'t be blank'
    end

    scenario 'composes a link with errors' do
      click_on 'Add Link to Question'
      fill_in 'Link name', with: ''
      fill_in 'Url', with: 'http:///google.com'
      click_on 'OK'

      expect(page).to have_content 'Links name can\'t be blank'
      expect(page).to have_content 'Links url is not a valid URL'
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

  context "multiple sessions" do
    scenario "the question appears on other users page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask a question'
        fill_in 'Title', with: 'Some Title'
        fill_in 'Body', with: 'Question with Some Text'
        click_on 'OK'
        expect(page).to have_content 'Your question created.'
        expect(page).to have_content 'Some Title'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'Some Title'
      end
    end
  end
end
