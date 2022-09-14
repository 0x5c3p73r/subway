
# frozen_string_literal: true

class CreateSystemDataService < ApplicationService
  def call
    subway = Rails.application.config_for(:subway)
    subway[:backend].each do |backend|
      Backend.find_or_create_by(name: backend[:name], link: backend[:link]) do |m|
        m.source = :system
      end
    end

    subway[:config].each do |config|
      Config.find_or_create_by(name: config[:name], link: config[:link]) do |m|
        m.source = :system
      end
    end
  end
end
