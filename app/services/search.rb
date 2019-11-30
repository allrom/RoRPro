class Services::Search
  RESOURCES = %w[All Question Answer Comment User].freeze

  def initialize(params)
    @resource = params[:resource]
    # Escape query terms with sphinx reserved characters (as '@')
    @query = ThinkingSphinx::Query.escape(params[:query])
  end

  def self.call(params)
    new(params).run
  end

  def run
    unless RESOURCES.without('All').include?(@resource)
      return  ThinkingSphinx.search(@query)
    end

    klass = @resource.constantize
    klass.search(@query)
  end
end
