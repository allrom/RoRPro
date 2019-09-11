module LinksHelper
  def gist_url?(url)
    url =~ /^(?i)https:\/\/gist\.github\.com\/(?=.{1,39}$)(?![_\W])[a-z0-9-]+(?<![_\W])\/([a-z0-9\/.]+)$/
  end
end
