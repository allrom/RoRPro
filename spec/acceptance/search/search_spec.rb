require 'sphinx_helper'

feature 'User or Guest can Seek Info', %q{
  In order to making search for data
  As an regular User or Guest
  I'd like to be able to Find it
} do
  describe 'Search', js: true, sphinx: true do

    before { visit root_path }

    context 'select "Question"' do
     given!(:questions) { create_list(:question, 2) }
     given(:attribute) { questions.first.title }

     it_behaves_like 'searched in', 'Question'
    end

    context 'select "Answer"' do
      given!(:answers) { create_list(:answer, 2) }
      given(:attribute) { answers.first.body }

      it_behaves_like 'searched in', 'Answer'
    end

    context 'select "Comment"' do
      given!(:comments) { create_list(:comment, 2) }
      given(:attribute) { comments.first.body }

      it_behaves_like 'searched in', 'Comment'
    end

    context 'select "User"' do
      given!(:users) { create_list(:user, 2) }
      given(:attribute) { users.first.email }

      it_behaves_like 'searched in', 'User'
    end

    context 'select "All"' do
      given!(:comments) { create_list(:comment, 2) }
      given(:attribute) { comments.first.commentable.body }

      it_behaves_like 'searched in', 'All'
    end
  end
end
