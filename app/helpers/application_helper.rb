module ApplicationHelper
  def flash_message
    flash.map do |type, message|
      content_tag :div, message, class: "flash #{type}" if flash[type]
    end.join.html_safe
  end
end
