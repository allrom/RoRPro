require 'rails_helper'

feature 'Delete own attachment', %q{
  In order to remove an attachment
  As an resource Owner
  I'd like to be able to Delete an Attachment
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:authors_question) { create :question, :with_attachment, user: author }
  given!(:visitors_question) { create :question, :with_attachment, user: visitor }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'deletes own attachment' do
      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on 'Edit'
      end

      within('#files-attached') do
        find("#file_id-#{authors_question.files.first.id}").click_on 'Remove'
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).not_to have_content authors_question.files.first.filename.to_s
      expect(current_path).to eq edit_question_path(authors_question)
    end

    scenario 'tries to delete visitors attachment' do
      visit question_path(visitors_question)
      within('#files-attached') do
        expect(find("#file_id-#{visitors_question.files.first.id}")).not_to have_link 'Remove'
      end
      expect(current_path).to eq question_path(visitors_question)
    end
  end

  scenario 'Unauthenticated user tries to delete an attachment' do
    visit edit_question_path(authors_question)
    expect(page).not_to have_link 'Remove'
  end
end
