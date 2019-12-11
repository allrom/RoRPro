module ApplicationHelper
  def flash_message
    flash.map do |type, message|
      content_tag :div, message, class: "flash #{type}" if flash[type]
    end.join.html_safe
  end

  def collection_cache_key_for(object)
    klass = object.class
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{klass.to_s.downcase.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
