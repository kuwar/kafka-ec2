# Overview
- Terraform is used to spin 3 nodes kafka cluster in AWS ec2 instances in KRaft mode
- For each node, elastic ip is assigned
- VPC, Subnets and security groups are created using terraform
- For monitoring, prometheus and grafana are used
- Each kafka function as controller and broker

## KRAFT
Apache Kafka® Raft (KRaft) is the consensus protocol that was introduced to remove Kafka’s dependency on 
ZooKeeper for metadata management

### KRaft configuration
process.roles=broker,controller
node.id=<ClusterUniqueID>
listeners=PLAINTEXT://:9092,CONTROLLER://:9093
advertised.listeners=PLAINTEXT://<Node1-Public-IP>:9092
controller.listener.names=CONTROLLER
controller.quorum.voters=1@<Node1-Private-IP>:9093,2@<Node2-Private-IP>:9093,3@<Node3-Private-IP>:9093
log.dirs=/var/lib/kafka/logs

## Different ports used
- prometheus               => 9090
- grafana                  => 3000
- jmxremote                => 7071
- jmxremote_rmi            => 7072
- jmx_prometheus_javaagent => 8080
- confluent_schema_registry => 8081
- kafka broker             => 9092
- kafka controller         => 9093


### Generate random cluster id
kafka_cluster_id = $(bin/kafka-storage.sh random-uuid)

### Formate the storage using randomly generated cluster id
/usr/local/kafka/bin/kafka-storage.sh format -t ussfzE8yTr-lVwg5nC3fCA -c /usr/local/kafka/config/kraft/server.properties

### Interaction with Kafka 
```bash
#!/bin/bash

./bin/kafka-topics.sh --create --topic first-topic --bootstrap-server <BrokerIP>:<BrokerPort> --replication-factor 2
./bin/kafka-topics.sh --create --topic first-topic --bootstrap-server <BrokerIP>:9092 --partitions 3 --replication-factor 3

./bin/kafka-topics.sh --describe --bootstrap-server <BrokerIP>:9092 --topic first-topic

```

## JMX Exporter
- is used to export cluster metrices
```bash
#!/bin/bash

curl https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/1.0.1/jmx_prometheus_javaagent-1.0.1.jar

# export KAFKA_OPTS="$KAFKA_OPTS -javaagent:/usr/local/kafka/prometheus/jmx_prometheus_javaagent-1.0.1.jar=7071:/usr/local/kafka/prometheus/kafka_jmx_config.yml"
```

# References
- https://docs.confluent.io/platform/current/kafka-metadata/kraft.html
- https://www.clairvoyant.ai/blog/kafka-series-3.-creating-3-node-kafka-cluster-on-virtual-box
- https://www.digitalocean.com/community/tutorials/how-to-set-up-a-multi-node-kafka-cluster-using-kraft

