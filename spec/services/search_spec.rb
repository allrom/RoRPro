require 'rails_helper'

RSpec.describe Services::Search do
  it 'searches all over the data when called with "All"' do
    expect(ThinkingSphinx).to receive(:search).with('some_text')
    Services::Search.call(query: 'some_text', resource: 'All')
  end

  Services::Search::RESOURCES.without('All').each do |resource|
    it "searches in resource when called with #{resource}" do
      expect(resource.constantize).to receive(:search).with('some_text')
      Services::Search.call(query: 'some_text', resource: resource)
    end
  end

  it 'returns an <empty> result when resource is unknown' do
    expect(Services::Search.call(query: 'some_text', resource: 'dummy_resource')).to be_empty
  end
end
