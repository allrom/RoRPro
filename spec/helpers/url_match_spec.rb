require 'spec_helper'

module LinksHelper
  def gist_url?(url)
    url =~ /^(?i)https:\/\/gist\.github\.com\/(?=.{1,39}$)(?![_\W])[a-z0-9-]+(?<![_\W])\/([a-z0-9\/.]+)$/
  end
end

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
