require 'rails_helper'

RSpec.shared_examples "comments_association" do
  it { should have_many(:comments).dependent(:destroy) }
end
