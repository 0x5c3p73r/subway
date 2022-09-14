Rails.application.configure do
  config.good_job = {
    queues: '*',
    max_threads: 5,
    preserve_job_records: false,
    cleanup_preserved_jobs_before_seconds_ago: 1.day.to_i,
    cleanup_interval_jobs: 100,
    cleanup_interval_seconds: 10.minutes.to_i

    # enable_cron: true,
    # cron: {
    #   example: {
    #     cron: '0 * * * *',
    #     class: 'ExampleJob'
    #   },
    # },
  }
end
