module CoachesHelper
  def system_backends
    Backend.all_system
  end

  def system_configs
    Config.all_system
  end

  def all_targets
    Coach::TARGETS.map { |value, name| [ name, value ] }
  end

  def target(key)
    key = key.to_sym if key.is_a?(String)
    Coach::TARGETS[key]
  end

  def subway_config
    @@subway_config ||=Rails.application.config_for(:subway)
  end
end
