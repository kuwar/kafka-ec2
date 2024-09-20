instance_type = "t2.xlarge"

apply_eip_resource = true

eip_ids = [
  "eipalloc-0f204b07f85645191",
  "eipalloc-05b3bc89855ffc6c1",
  "eipalloc-070cbb309db78d172"
]

kraft_config_files = [
  "kafka-config/kraft/server1.properties",
  "kafka-config/kraft/server2.properties",
  "kafka-config/kraft/server3.properties"
]