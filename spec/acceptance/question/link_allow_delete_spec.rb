require 'rails_helper'

feature 'Delete own link', %q{
  In order to remove a link
  As an resource Owner
  I'd like to be able to Delete a Link
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:authors_question) { create :question, :with_link, user: author }
  given!(:visitors_question) { create :question, :with_link, user: visitor }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'deletes own link' do
      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on 'Edit'
      end

      within('#links-binded') do
        expect(page).to have_content authors_question.links.first.name
        find("#link_id-#{authors_question.links.first.id}").click_on 'Remove'
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).not_to have_content authors_question.links.first.name
      expect(current_path).to eq edit_question_path(authors_question)
    end

    scenario 'tries to delete visitors link' do
      visit question_path(visitors_question)
      within('#links-binded') do
        expect(find("#link_id-#{visitors_question.links.first.id}")).not_to have_link 'Remove'
      end
      expect(current_path).to eq question_path(visitors_question)
    end
  end

  scenario 'Unauthenticated user tries to delete a link' do
    visit edit_question_path(authors_question)
    expect(page).not_to have_link 'Remove'
  end
end
