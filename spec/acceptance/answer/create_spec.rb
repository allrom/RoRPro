require 'rails_helper'

feature 'User can give an answer to a question', %q{
  In order to make Help to community
  As an Autheticated user
  I'd like to be able to Create answers
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'answer-given', with: 'Answer with Some Text'
    end

    scenario 'gives an answer' do
      click_on 'OK'
      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Answer added'

      within('.answer-list') do
        expect(page).to have_content 'Answer with Some Text'
      end
     end

    scenario 'gives an answer and attaches some files' do
      expect(current_path).to eq question_path(question)
      page.attach_file 'answer[files][]',
                       ["#{Rails.root}/spec/rails_helper.rb",  "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'OK'
      expect(page).to have_content 'Answer added'

      within('#answers-table') do
        ## page.find(:css, 'td.table-data', text: /^'Answer with Some Text'$/)
        ## find('a[href$="Files"]').click
        ## page.find(:xpath, ".//tr[./td[@class ='table-view']]")
        click_on 'Files'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'gives an answer with errors' do
      fill_in 'answer-given', with: ''
      click_on 'OK'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)
    expect(page).not_to have_field 'Give an Answer'
    expect(page).not_to have_selector(:link_or_button, 'OK')
  end
end
