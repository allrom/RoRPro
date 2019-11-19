require 'rails_helper'

RSpec.shared_examples "question_association" do
  it { should belong_to(:question) }
end
