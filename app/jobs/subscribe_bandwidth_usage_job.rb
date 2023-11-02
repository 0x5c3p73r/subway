class SubscribeBandwidthUsageJob < ApplicationJob
  queue_as :default

  def perform(subscribe_id: nil)
    if subscribe_id.present?
      return Subscribe.find(subscribe_id).bandwidth_check
    end

    Subscribe.all.each do |subscribe|
      subscribe.bandwidth_check
    end
  end
end
