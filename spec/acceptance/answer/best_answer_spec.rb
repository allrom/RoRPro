require 'rails_helper'

feature 'Mark the best answer', %q{
  In order to mark the most helpful answer
  As an question Owner
  I'd like to be able to Flag best answer
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:visitor_question) { create :question, :with_answer, user: visitor }
  given!(:author_question) { create :question, :with_answer, user: author }

  given!(:visitor_answer_1) { create :answer, question: author_question, user: visitor }
  given!(:visitor_answer_2) { create :answer, question: author_question, user: visitor }

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit question_path(author_question)
    end

    scenario 'selector "best!" is present' do
      expect(page).to have_selector("input[type = submit][value = 'best!']")
      ## save_and_open_page
    end

    scenario 'mark visitor answer as "best!"' do
      within('#answers-table') do
       find("#answer_id-#{visitor_answer_1.id}").click_on 'best!'
       expect(page).to have_content "Best Answer"
       expect(page.find("#answer_id-#{visitor_answer_2.id}")).not_to  have_content "Best Answer"
      end
    end

    scenario 'unable to flag visitors question answers' do
      visit question_path(visitor_question)
      expect(page).not_to have_selector("input[type = submit][value = 'best!']")
    end
   end

  describe 'Visitor', js: true do
    background do
      sign_in(visitor)
      visit question_path(visitor_question)
    end

    scenario 'selector "best!" is present' do
      expect(page).to have_selector("input[type = submit][value = 'best!']")
    end

    scenario 'unable to flag authors question answers' do
      visit question_path(author_question)
      expect(page).not_to have_selector("input[type = submit][value = 'best!']")
    end
   end

  scenario 'Unauthenticated user tries to flag best answer' do
    visit question_path(visitor_question)
    expect(page).not_to have_selector("input[type = submit][value = 'best!']")
    visit question_path(author_question)
    expect(page).not_to have_selector("input[type = submit][value = 'best!']")
  end
end
