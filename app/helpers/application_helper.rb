module ApplicationHelper
  def subway(version: true)
    name = "Subway"
    version = ENV["DOCKER_META_VERSION"] || Subway::VERSION
    name = "#{name} v#{version}" if version
    name = "#{name}-dev" if Rails.env.development?
    name
  end

  def page_title(title = nil)
    app_name = subway(version: false)
    title.present? ? "#{title} - #{app_name}" : app_name
  end

  def locale_image_tag(source, options = {})
    new_source = I18n.locale == :en ? source : "#{I18n.locale}/#{source}"
    image_tag(new_source, options)
  end

  def dashboard_enable?
    Rails.env.development?
  end

  def tools_enable?
    Rails.env.development?
  end
end
