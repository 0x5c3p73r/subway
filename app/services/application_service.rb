
# frozen_string_literal: true

class ApplicationService
  def self.call(**args)
    new.call(**args)
  end

  def call(**args)
    raise 'Not implements'
  end
end
