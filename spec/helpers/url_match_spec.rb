require 'rails_helper'

describe ApplicationHelper do
  let(:gist_matcher) { /^(?i)https:\/\/gist\.github\.com\/(?=.{1,39}$)(?![_\W])[a-z0-9-]+(?<![_\W])\/([a-z0-9\/.]+)$/ }
  let(:gist_url) { 'https://gist.github.com/allrom/4fefa05558dfdd546abd122f057ebdc2' }

  describe '#gist_url?' do
   it "correctly parces the gist url" do
     expect(gist_url).to match(gist_matcher)
   end
  end
end
