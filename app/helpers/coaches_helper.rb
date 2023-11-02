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

  def bandwidth_usage(subscribe)
    return '-' if subscribe.total_bandwidth.blank?

    used = (subscribe.upload_used || 0) + (subscribe.download_used || 0)

    used_human = number_to_human_size(used, precision: 2)
    total_human = number_to_human_size(subscribe.total_bandwidth, precision: 2)

    "#{used_human} / #{total_human}"
  end
end
