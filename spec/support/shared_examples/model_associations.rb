require 'rails_helper'

RSpec.shared_examples "model_associations" do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should belong_to(:user) }
end
