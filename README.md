# /etc/systemd/system/kafka.service
# Start and enable Kafka
sudo systemctl daemon-reload
sudo systemctl enable kafka
sudo systemctl start kafka

# /etc/systemd/system/zookeeper.service
# Start and enable Zookeeper
sudo systemctl daemon-reload
sudo systemctl enable zookeeper
sudo systemctl start zookeeper


-- References
https://www.clairvoyant.ai/blog/kafka-series-3.-creating-3-node-kafka-cluster-on-virtual-box
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-multi-node-kafka-cluster-using-kraft



...
controller.quorum.voters=<id-node-1>@<private-ip-node-1>:9093,<id-node-2>@<private-ip-node-2>:9093,<id-node-3>@<private-ip-node-3>:9093
...

listeners=PLAINTEXT://:9092,CONTROLLER://:9093
advertised.listeners=PLAINTEXT://<broker-public-ip>:9092

num.partitions=6

offsets.topic.replication.factor=2
transaction.state.log.replication.factor=2

-----
process.roles=broker,controller
node.id=1
listeners=PLAINTEXT://:9092,CONTROLLER://:9093
advertised.listeners=PLAINTEXT://<Node1-Public-IP>:9092
controller.listener.names=CONTROLLER
controller.quorum.voters=1@<Node1-Private-IP>:9093,2@<Node2-Private-IP>:9093,3@<Node3-Private-IP>:9093
log.dirs=/var/lib/kafka/logs


----------
bin/kafka-topics.sh --bootstrap-server <Node1-Public-IP>:9092 --describe

bin/kafka-topics.sh --create --topic test-topic --partitions 3 --replication-factor 3 --bootstrap-server localhost:9092

bin/kafka-topics.sh --bootstrap-server 15.188.211.194:9092 --describe


kafka_cluster_id = $(bin/kafka-storage.sh random-uuid)


/usr/local/kafka/bin/kafka-storage.sh format -t ussfzE8yTr-lVwg5nC3fCA -c /usr/local/kafka/config/kraft/server.properties

./bin/kafka-metadata-quorum.sh --bootstrap-controller 172.31.7.165:9093 describe --status

./bin/kafka-topics.sh --create --topic first-topic --bootstrap-server 15.237.176.130:9092 --replication-factor 2
./bin/kafka-topics.sh --create --topic first-topic --bootstrap-server 172.31.7.165:9092 --partitions 3 --replication-factor 3


./bin/kafka-topics.sh --describe --bootstrap-server 15.237.176.130:9092 --topic first-topic

./bin/kafka-console-producer.sh --broker-list 13.38.44.59:9092,15.188.238.177:9092,13.38.96.58:9092 --topic test

sudo useradd --no-create-home --shell /bin/false kafka

