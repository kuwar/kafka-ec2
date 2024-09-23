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
controller.quorum.voters=1@15.188.211.194:9093,2@13.38.157.254:9093,3@13.37.33.32:9093
...

listeners=PLAINTEXT://13.37.33.32:9092,CONTROLLER://13.37.33.32:9093
advertised.listeners=PLAINTEXT://13.37.33.32:9092

num.partitions=6

offsets.topic.replication.factor=2
transaction.state.log.replication.factor=2



------
kafka-cluster-eip-1 -> 15.188.255.81, private ip -> 172.31.7.161

kafka-cluster-eip-2 -> 35.180.161.69, private ip -> 172.31.13.55

kafka-cluster-eip-3 -> 15.236.105.35, private ip -> 172.31.11.182

1@172.31.7.161:9093,2@172.31.13.55:9093,3@172.31.11.182:9093

ec2_instance_private_ip = [
  "172.31.1.177",
  "172.31.3.63",
  "172.31.6.190",
]
ec2_instance_public_ip = [
  "13.37.62.220",
  "35.181.246.206",
  "35.181.28.139",
]

sudo chmod -R 777 /usr/local/kafka


-----$_COOKIEprocess.roles=broker,controller
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
