instance_type = "t2.xlarge"

apply_eip_resource = true

kafka_cluster_id = "WbwIBObxTu6uaOlkwPwZeg0"

total_node = 3

kafka_install_path = "/usr/local/kafka"

jmx_prometheus_javaagent_jar_path = "/usr/local/kafka/prometheus"

kafka_log_path = "/usr/local/kafka/data/broker/logs"

offsets_topic_replication_factor = 2

transaction_state_log_replication_factor = 2

kafka_cluster_ports = {
  broker     = 9092
  controller = 9093
}

monitoring_ports = {
  prometheus               = 9090
  grafana                  = 3000
  jmxremote                = 7071
  jmxremote_rmi            = 7072
  jmx_prometheus_javaagent = 8080
}

confluent_schema_registry_port = 8081

