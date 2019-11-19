require 'rails_helper'

feature 'Subscribe to Question Update', %q{
  In order to get info about new answers
  As an authenticated user
  I'd like to be able to (un)subscribe to a question.
} do
  given(:author) { create(:user) }
  given(:visitor) { create(:user) }
  given!(:question) { create :question, user: author }

  describe 'Visitor', js: true do
    background do
      sign_in(visitor)
      visit question_path(question)
    end

    scenario 'visitor can subscribe to a question' do
      within("#subscriptions-proposed") do
        expect(page).to have_selector("input[type = submit][value = 'Subscribe']")
        expect(page).to_not have_selector("input[type = submit][value = 'Unsubscribe']")
        click_on 'Subscribe'

        expect(page).to have_selector("input[type = submit][value = 'Unsubscribe']")
        expect(page).to_not have_selector("input[type = submit][value = 'Subscribe']")
      end
      expect(page).to have_content 'Subscribed from now'
    end

    scenario 'visitor can unsubscribe from a question' do
      within(".subscriptions") do
        click_on 'Subscribe'
        click_on 'Unsubscribe'

        expect(page).to have_selector("input[type = submit][value = 'Subscribe']")
        expect(page).to_not have_selector("input[type = submit][value = 'Unsubscribe']")
      end
      expect(page).to have_content 'Successfully unsubscribed'
    end
  end

  describe 'Author', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'autor cannot subscribe to ones question' do
      within(".subscriptions") do
        expect(page).to have_selector("input[type = submit][value = 'Unsubscribe']")
        expect(page).to_not have_selector("input[type = submit][value = 'Subscribe']")
      end
    end

    scenario 'author can unsubscribe from ones question' do
      within(".subscriptions") do
        click_on 'Unsubscribe'

        expect(page).to have_selector("input[type = submit][value = 'Subscribe']")
        expect(page).to_not have_selector("input[type = submit][value = 'Unsubscribe']")
      end
      expect(page).to have_content 'Successfully unsubscribed'
    end
  end

  describe 'Guest', js: true do
    background do
      visit question_path(question)
    end

    scenario 'guest is unable to (un)subscribe from(to) question' do
      within("body") do
        expect(page).to_not have_selector("input[type = submit][value = 'Unsubscribe']")
        expect(page).to_not have_selector("input[type = submit][value = 'Subscribe']")
      end
    end
  end
end
