require 'rails_helper'

feature 'Vote for Answer', %q{
  In order to Evaluate an Answer
  As a resource visitor
  I'd like to be able to up/down vote for it.
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }

  given!(:author_question) { create :question, user: author }
  given!(:visitor_answer) { create :answer, question: author_question, user: visitor }

  given!(:visitor_question) { create :question, user: visitor }
  given!(:author_answer) { create :answer, question: visitor_question, user: author }

  describe 'Visitor', js: true do
    background do
      sign_in(visitor)
      visit question_path(visitor_question)
    end

    scenario 'upvotes an answer' do
      within('#answers-table') do
        find("#answer_id-#{author_answer.id}").click_on '+UpVote'
        expect(page).to have_content '1'
      end
    end

    scenario 'downvotes an answer' do
      within('#answers-table') do
        find("#answer_id-#{author_answer.id}").click_on '-DownVote'
        expect(page).to have_content '-1'
      end
    end

    scenario 'drops own votes' do
      within('#answers-table') do
        within("#answer_id-#{author_answer.id}") do
          click_on '+UpVote'
          expect(page).to have_content '1'
          sleep(1)
          click_on 'DropVote'
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'disallows multiple votes' do
      within('#answers-table') do
        within("#answer_id-#{author_answer.id}") do
          click_on '+UpVote'
          sleep(1)
          click_on '+UpVote'
        end
        within('.vote-errors') do
          expect(page).to have_content 'Vote is not allowed'
        end
      end
    end
   end

  describe 'Visitor as an Author', js: true do
    background do
      sign_in(visitor)
      visit question_path(author_question)
    end

    scenario 'unable to vote self' do
      within('#answers-table') do
        within("#answer_id-#{visitor_answer.id}") do
          expect(page).not_to have_selector("input[type = submit][value = '+UpVote']")
          expect(page).not_to have_selector("input[type = submit][value = '-DownVote']")
          expect(page).not_to have_selector("input[type = submit][value = 'DropVote']")
        end
      end
    end
  end

  describe 'Guest', js: true do
    background do
      visit question_path(visitor_question)
    end

    scenario 'unable to vote' do
      within('#answers-table') do
        within("#answer_id-#{author_answer.id}") do
          expect(page).not_to have_selector("input[type = submit][value = '+UpVote']")
          expect(page).not_to have_selector("input[type = submit][value = '-DownVote']")
          expect(page).not_to have_selector("input[type = submit][value = 'DropVote']")
        end
      end
    end
  end
end
