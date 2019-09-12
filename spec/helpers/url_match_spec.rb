require 'spec_helper'
require 'links_helper'

class TestClass
  include LinksHelper
end

RSpec.describe LinksHelper do
  let(:url) { 'https://gist.github.com/allrom/4fefa05558dfdd546abd122f057ebdc2' }

  it "correctly parces the gist url" do
    testins = TestClass.new
    expect(testins).to be_gist_url(url)
  end
end
