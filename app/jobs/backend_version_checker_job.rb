class BackendVersionCheckerJob < ApplicationJob
  queue_as :default

  def perform(backend_id: nil)
    if backend_id.present?
      return Backend.find(backend_id).version_check
    end

    Backend.all.each do |backend|
      backend.version_check
    end
  end
end
