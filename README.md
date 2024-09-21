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
kafka-cluster-eip-1 -> 15.188.211.194, private ip -> 172.31.2.32

kafka-cluster-eip-2 -> 13.38.157.254, private ip -> 172.31.12.175

kafka-cluster-eip-3 -> 13.37.33.32, private ip -> 172.31.0.209


sudo chmod -R 777 /usr/local/kafka


-----$_COOKIEprocess.roles=broker,controller
node.id=1
listeners=PLAINTEXT://<Node1-Private-IP>:9092,CONTROLLER://<Node1-Private-IP>:9093
advertised.listeners=PLAINTEXT://<Node1-Public-IP>:9092
controller.listener.names=CONTROLLER
controller.quorum.voters=1@<Node1-Private-IP>:9093,2@<Node2-Private-IP>:9093,3@<Node3-Private-IP>:9093
log.dirs=/var/lib/kafka/logs


----------
bin/kafka-topics.sh --bootstrap-server <Node1-Public-IP>:9092 --describe

bin/kafka-topics.sh --create --topic test-topic --partitions 3 --replication-factor 3 --bootstrap-server localhost:9092

bin/kafka-topics.sh --bootstrap-server 15.188.211.194:9092 --describe
