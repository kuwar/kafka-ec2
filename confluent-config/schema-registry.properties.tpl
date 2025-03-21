#
# Copyright 2018 Confluent Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# The address the socket server listens on.
#   FORMAT:
#     listeners = listener_name://host_name:port
#   EXAMPLE:
#     listeners = PLAINTEXT://your.host.name:9092
listeners=http://0.0.0.0:8081

# Use this setting to specify the bootstrap servers for your Kafka cluster and it
# will be used both for selecting the leader schema registry instance and for storing the data for
# registered schemas.
kafkastore.bootstrap.servers=${brokers_list}

# The name of the topic to store schemas in
kafkastore.topic=_schemas

# If true, API requests that fail will include extra debugging information, including stack traces
debug=false

metadata.encoder.secret=REPLACE_ME_WITH_HIGH_ENTROPY_STRING

resource.extension.class=io.confluent.dekregistry.DekRegistryResourceExtension
