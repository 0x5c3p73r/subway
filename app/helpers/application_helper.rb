module ApplicationHelper
  def page_title(title = nil)
    title.present? ? "#{title} - Subway" : "Subway"
  end

  def locale_image_tag(source, options = {})
    new_source = I18n.locale == :en ? source : "#{I18n.locale}/#{source}"
    image_tag(new_source, options)
  end
end
