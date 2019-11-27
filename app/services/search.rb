class Services::Search
  RESOURCES = %w[All Question Answer Comment User].freeze

  def initialize(params)
    @query_resource = params[:resource]
    # Escape query terms with sphinx reserved characters (as '@')
    @query_text = ThinkingSphinx::Query.escape(params[:query])
  end

  def self.call(params)
    new(params).run
  end

  def run
    return [] unless @query_resource.in?(RESOURCES)

    search(@query_resource)
  end

  private

  def search(query_resource)
    query_resource == 'All' ? ThinkingSphinx.search(@query_text) : @query_resource.constantize.search(@query_text)
  end
end
