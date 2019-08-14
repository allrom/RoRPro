require 'rails_helper'

feature 'Delete own question', %q{
  In order to remove a question
  As an question Owner
  I'd like to be able to Delete a Question
} do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:authors_question) { create :question, user: author }
  given!(:users_question) { create :question, user: user }

  describe 'Author' do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'deletes own question' do
      within "#question_id-#{authors_question.id}" do
        click_on 'Remove'
      end
      expect(page).not_to have_content authors_question.title
      expect(current_path).to eq questions_path
    end

    scenario 'tries to deletes users question' do
      within "#question_id-#{users_question.id}" do
        click_on 'Remove'
      end
      expect(page).to have_content users_question.title
      expect(page).to have_content 'Not allowed'
      expect(current_path).to eq questions_path
    end
   end

  scenario 'Unauthenticated user tries to delete a question' do
    visit questions_path
    expect(page).not_to have_link 'Remove'
  end
end
