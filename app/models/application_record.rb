class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  protected

  def generate_name
    return if name.present?

    self.name = URI.parse(link).hostname
  end
end
