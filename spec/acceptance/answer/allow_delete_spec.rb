require 'rails_helper'

feature 'Delete own answer', %q{
  In order to remove an answer
  As an answer Owner
  I'd like to be able to Delete an Answer
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:authors_answer) { create :answer, question: question, user: author }
  given!(:users_answer) { create :answer, question: question, user: user }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'deletes own answer' do
      within "#answer_id-#{authors_answer.id}" do
        click_on 'Remove'
        # accepts 'OK to remove?' alert
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).not_to have_content authors_answer.body
      expect(current_path).to eq question_path(question)
    end

    scenario 'tries to deletes users answer' do
      within "#answer_id-#{users_answer.id}" do
        expect(page).not_to have_link 'Remove'
      end
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Unauthenticated user tries to delete an answer' do
    visit question_path(question)
    expect(page).not_to have_link 'Remove'
  end
end
