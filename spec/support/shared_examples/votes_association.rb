require 'rails_helper'

RSpec.shared_examples "votes_association" do
  it { should have_many(:votes).dependent(:destroy) }
end
