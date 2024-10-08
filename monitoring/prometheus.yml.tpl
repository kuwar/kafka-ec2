scrape_configs:
  - job_name: 'kafka_cluster_job'
    static_configs:
      - targets: ${brokers_list}
