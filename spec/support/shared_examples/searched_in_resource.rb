require 'sphinx_helper'

RSpec.shared_examples "searched in" do |context|
  scenario "searching in #{context} with valid query" do
    ThinkingSphinx::Test.run do
      within '#search-form' do
        fill_in 'query', with: attribute
        select "#{context}", from: 'resource'

        click_on 'Search!'
      end

      within '#search-result' do
        expect(page).to  have_content attribute
        expect(page).to  have_content 'Found 1'
      end
    end
  end

  scenario "searching in #{context} with invalid query" do
    ThinkingSphinx::Test.run do
      within '#search-form' do
        fill_in 'query', with: ''
        select "#{context}", from: 'resource'

        click_on 'Search!'
      end

      within '#search-result' do
        expect(page).to  have_content 'Nothing Found'
      end
      expect(page).to  have_content 'Empty search given'
    end
  end
end
