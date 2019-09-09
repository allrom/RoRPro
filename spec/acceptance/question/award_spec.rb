require 'rails_helper'

feature 'Give some Award', %q{
  In order to thank the most helpful answer
  As an question Owner
  I'd like to be able to Flag best answer
  and give an Award to best answer's author
} do
  given!(:author) { create(:user) }
  given!(:visitor) { create(:user) }
  given!(:author_question) { create :question, :with_answer, :with_award, user: author }
  given!(:visitor_answer) { create :answer, question: author_question, user: visitor }

  describe 'Award', js: true do
    scenario 'mark visitor answer as "best!" and give an award' do
      sign_in(author)
      visit question_path(author_question)
      within('#answers-table') do
       find("#answer_id-#{visitor_answer.id}").click_on 'best!'
       expect(page).to have_content "Best Answer"
      end

      expect(page).not_to have_link 'View Awards'

      click_on 'Sign out'
      sign_in(visitor)
      click_on 'View Awards'
      expect(page).to have_content "#{author_question.award.name}"
    end
   end

  scenario 'Unauthenticated user tries to flag best answer' do
    visit question_path(author_question)
    expect(page).not_to have_selector("input[type = submit][value = 'best!']")
  end
end


