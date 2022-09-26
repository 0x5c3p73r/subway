
# frozen_string_literal: true

class CreateSystemDataService < ApplicationService
  def call
    subway = Rails.application.config_for(:subway)
    subway[:backend].each do |backend|
      Backend.find_or_create_by(link: backend[:link]) do |m|
        m.name = backend[:name]
        m.source = :system
      end
    end

    subway[:config].each do |config|
      Config.find_or_create_by(link: config[:link]) do |m|
        m.name = config[:name]
        m.source = :system
      end
    end

    if (local_backend = ENV['LOCAL_BACKEND_URL']) && local_backend.present?
      Backend.find_or_create_by(link: local_backend) do |m|
        m.name = 'local'
        m.source = :system
      end
    end
  end
end
