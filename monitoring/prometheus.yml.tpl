scrape_configs:
  - job_name: 'kafka'
    static_configs:
      - targets: ${brokers_list}
