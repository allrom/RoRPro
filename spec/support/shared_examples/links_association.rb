require 'rails_helper'

RSpec.shared_examples "links_association" do
  it { should have_many(:links).dependent(:destroy) }
end
