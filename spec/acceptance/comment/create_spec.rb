require 'rails_helper'

feature 'User can post a comment', %q{
  In order to make some clarification to resorce
  As an Autheticated user
  I'd like to be able to Post comments
} do
  given!(:user) { create(:user) }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'post comment to the question' do
      within('.post-comment') do
        fill_in 'comment-posted', with: 'Some Question Comment'
        click_on 'OK'
      end
      expect(page).to have_content 'Some Question Comment'
    end

    scenario 'composes a question comment with errors' do
      within('.post-comment') do
        fill_in 'comment-posted', with: ''
        click_on 'OK'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'post comment to the answer' do
      within('#answers-table') do
        fill_in 'comment-posted', with: 'Some Answer Comment'
        click_on 'OK'
      end
      expect(page).to have_content 'Some Answer Comment'
    end

    scenario 'composes an answer comment with errors' do
      within('#answers-table') do
        fill_in 'comment-posted', with: ''
        click_on 'OK'
      end
      expect(page).to have_content "Body can't be blank"
    end
  end

  context "multiple sessions" do
    scenario "question comment appears on other users page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.post-comment') do
          fill_in 'comment-posted', with: 'Some Question Comment'
          click_on 'OK'
        end
        expect(page).to have_content 'Some Question Comment'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'Some Question Comment'
      end
    end
  end

  scenario 'Unauthenticated user tries to post a comment' do
    visit question_path(question)
    expect(page).not_to have_field 'Post a comment'
    expect(page).not_to have_selector(:link_or_button, 'OK')
  end
end
