require 'rails_helper'

RSpec.shared_examples "files_as_attachments" do
  it 'has many attached files as attachments' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
