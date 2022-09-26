module ApplicationHelper
  def page_title(title = nil)
    title.present? ? "#{title} - Subway" : "Subway"
  end
end
