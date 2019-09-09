require 'rails_helper'

feature 'Delete own link', %q{
  In order to remove a link
  As an resource Owner
  I'd like to be able to Delete a Link
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:authors_q_w_link) { create :question, :with_link, user: author }
  given!(:visitors_q_w_link) { create :question, :with_link, user: visitor }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'deletes own link' do
      within('#questions-table') do
        find("#question_id-#{authors_q_w_link.id}").click_on 'Edit'
      end

      within('#links-binded') do
        find("#link_id-#{authors_q_w_link.links.first.id}").click_on 'Remove'
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).not_to have_content authors_q_w_link.links.first.name
      expect(current_path).to eq edit_question_path(authors_q_w_link)
    end

    scenario 'tries to delete visitors link' do
      visit question_path(visitors_q_w_link)
      within('#links-binded') do
        expect(find("#link_id-#{visitors_q_w_link.links.first.id}")).not_to have_link 'Remove'
      end
      expect(current_path).to eq question_path(visitors_q_w_link)
    end
  end

  scenario 'Unauthenticated user tries to delete a link' do
    visit edit_question_path(authors_q_w_link)
    expect(page).not_to have_link 'Remove'
  end
end
