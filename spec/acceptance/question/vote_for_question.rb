require 'rails_helper'

feature 'Vote for Question', %q{
  In order to Evaluate a Question
  As a resource visitor
  I'd like to be able to up/down vote for it.
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:authors_question) { create :question, user: author }

  describe 'Visitor', js: true do
    background do
      sign_in(visitor)
      visit questions_path
    end

    scenario 'upvotes a question' do
      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on '+UpVote'
        expect(page).to have_content '1'
      end
    end

    scenario 'downvotes a question' do
      within('#questions-table') do
        find("#question_id-#{authors_question.id}").click_on '-DownVote'
        expect(page).to have_content '-1'
      end
    end

    scenario 'drops own votes' do
      within('#questions-table') do
        within("#question_id-#{authors_question.id}") do
          click_on '+UpVote'
          expect(page).to have_content '1'
          sleep(1)
          click_on 'DropVote'
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'disallows multiple votes' do
      within('#questions-table') do
        within("#question_id-#{authors_question.id}") do
          click_on '+UpVote'
          sleep(1)
          click_on '+UpVote'
        end
      end
      within('body') do
        expect(page).to have_content "You are not authorized"
      end
    end
   end

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit questions_path
    end

    scenario 'unable to vote self' do
      within('#questions-table') do
        within("#question_id-#{authors_question.id}") do
          expect(page).not_to have_selector("input[type = submit][value = '+UpVote']")
          expect(page).not_to have_selector("input[type = submit][value = '-DownVote']")
          expect(page).not_to have_selector("input[type = submit][value = 'DropVote']")
        end
      end
    end
  end

  describe 'Guest', js: true do
    background do
      visit questions_path
    end

    scenario 'unable to vote' do
      within('#questions-table') do
        within("#question_id-#{authors_question.id}") do
          expect(page).not_to have_selector("input[type = submit][value = '+UpVote']")
          expect(page).not_to have_selector("input[type = submit][value = '-DownVote']")
          expect(page).not_to have_selector("input[type = submit][value = 'DropVote']")
        end
      end
    end
  end
end
