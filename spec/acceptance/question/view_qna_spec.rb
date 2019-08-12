require 'rails_helper'

feature 'User can view a question and a list of answers', %q(
  In order to view a Question and a List of answers
  As an regular User
  I'd like to be able to View question and Access answers index
) do
  given!(:questions) { create_list(:question, 3) }

  scenario 'regular user lists question answers' do
    ## visit question_path(questions.first)
    visit questions_path
    click_link('View', match: :first)
    expect(current_path).to eq question_path(questions.first)
  end
end
