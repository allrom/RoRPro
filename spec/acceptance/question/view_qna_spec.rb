require 'rails_helper'

feature 'User can view a question and a list of answers', %q{
  In order to view a Question and a List of answers
  As an regular User
  I'd like to be able to View question and its answers
} do
  given(:question) { create(:question, :with_answers) }

  scenario 'regular user lists question answers' do
    visit question_path(question)

    expect(page).to have_content(question.answers.first.body)
    expect(page).to have_content(question.answers.last.body)
  end
end
