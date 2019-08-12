require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to view a List of questions
  As an regular User
  I'd like to be able to Access index
} do
  given!(:questions) { create_list(:question, 3) }

  scenario 'regular user lists questions' do
    visit questions_path
    expect(page).to have_content(questions.first.title)
    expect(page).to have_content(questions.last.title)
  end

  scenario 'regular user reviews selected question' do
    visit questions_path
    click_link('View', match: :first)
    expect(current_path).to eq question_path(questions.first)
   end
end
