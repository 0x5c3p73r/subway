Rails.application.configure do
  config.good_job = {
    queues: "*",
    max_threads: 5,
    preserve_job_records: false,
    cleanup_preserved_jobs_before_seconds_ago: 1.day.to_i,
    cleanup_interval_jobs: 100,
    cleanup_interval_seconds: 10.minutes.to_i,

    enable_cron: true,
    cron: {
      syncing_backend_version: {
        cron: "0 */5 * * *",
        class: "BackendVersionCheckerJob",
        description: "Syncing and storing subconverter api version"
      },
      syncing_subscribe_bandwidth: {
        cron: "0 */5 * * *",
        class: "SubscribeBandwidthUsageJob",
        description: "Syncing and storing subscribe bandwidth usages"
      }
    }
  }
end
