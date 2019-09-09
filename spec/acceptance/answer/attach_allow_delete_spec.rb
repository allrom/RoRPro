require 'rails_helper'

feature 'Delete own attachment', %q{
  In order to remove an attachment
  As an resource Owner
  I'd like to be able to Delete an Attachment
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:authors_question) { create :question, user: author }
  given!(:authors_a_w_file) { create :answer, :with_attachment, question: authors_question, user: author }
  given!(:visitors_a_w_file) { create :answer, :with_attachment, question: authors_question, user: visitor }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit question_path(authors_question)
    end

    scenario 'deletes own attachment' do
      within('#answers-table') do
        find("#answer_id-#{authors_a_w_file.id}").click_on 'Edit'
      end

      within('#files-attached') do
        find("#file_id-#{authors_a_w_file.files.first.id}").click_on 'Remove'
        page.driver.browser.switch_to.alert.accept
      end
      expect(page).not_to have_content authors_a_w_file.files.first.filename.to_s
      expect(current_path).to eq edit_answer_path(authors_a_w_file)
    end

    scenario 'tries to delete visitors attachment' do
      within('#answers-table') do
        expect(find("#answer_id-#{visitors_a_w_file.id}")).not_to have_link 'Edit'
        find("#answer_id-#{visitors_a_w_file.id}").click_on 'Files'
        expect(find("#file_id-#{visitors_a_w_file.files.first.id}")).not_to have_link 'Remove'
      end
      expect(current_path).to eq question_path(authors_question)
    end
  end

  describe 'Visitor', js: true do
    scenario 'Unauthenticated user tries to delete an attachment' do
      visit question_path(authors_question)
      within('#answers-table') do
        expect(page).not_to have_link 'Edit'
        find("#answer_id-#{authors_a_w_file.id}").click_on 'Files'
      end
      expect(page).not_to have_link 'Remove'
    end
  end
end
