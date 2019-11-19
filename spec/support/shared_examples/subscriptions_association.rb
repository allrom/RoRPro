require 'rails_helper'

RSpec.shared_examples "subscriptions_association" do
  it { should have_many(:subscriptions).dependent(:destroy) }
end
