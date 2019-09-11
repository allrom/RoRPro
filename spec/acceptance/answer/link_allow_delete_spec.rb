require 'rails_helper'

feature 'Delete own link', %q{
  In order to remove a link
  As an resource Owner
  I'd like to be able to Delete a Link
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:authors_question) { create :question, user: author }
  given!(:authors_answer) { create :answer, :with_link, question: authors_question, user: author }
  given!(:visitors_answer) { create :answer, :with_link, question: authors_question, user: visitor }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit question_path(authors_question)
    end

    scenario 'deletes own link' do
      within('#answers-table') do
        find("#answer_id-#{authors_answer.id}").click_on 'Edit'
      end

      within('#links-binded') do
        find("#link_id-#{authors_answer.links.first.id}").click_on 'Remove'
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).not_to have_content authors_answer.links.first.name
      expect(current_path).to eq edit_answer_path(authors_answer)
    end

    scenario 'tries to delete visitors link' do
      within('#answers-table') do
        expect(find("#answer_id-#{visitors_answer.id}")).not_to have_link 'Edit'
        find("#answer_id-#{visitors_answer.id}").click_on 'Links'
        expect(find("#link_id-#{visitors_answer.links.first.id}")).not_to have_link 'Remove'
      end
      expect(current_path).to eq question_path(authors_question)
    end
  end

  describe 'Visitor', js: true do
    scenario 'Unauthenticated user tries to delete a link' do
      visit question_path(authors_question)
      within('#answers-table') do
        expect(page).not_to have_link 'Edit'
        find("#answer_id-#{authors_answer.id}").click_on 'Links'
      end
      expect(page).not_to have_link 'Remove'
    end
  end
end
