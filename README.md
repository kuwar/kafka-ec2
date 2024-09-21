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
kafka-cluster-eip-1 -> 15.188.211.194

kafka-cluster-eip-2 -> 13.38.157.254

kafka-cluster-eip-3 -> 13.37.33.32


sudo chmod -R 777 /usr/local/kafka
