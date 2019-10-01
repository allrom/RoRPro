require 'rails_helper'

RSpec.shared_examples "user_association" do
  it { should belong_to(:user) }
end
