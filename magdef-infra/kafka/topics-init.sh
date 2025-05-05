#!/bin/bash
set -e

KAFKA_BROKER="kafka:9092"
SCHEMA_REGISTRY_URL="http://schema-registry:8081"

echo "Waiting for Kafka to be available..."
sleep 10

kafka-topics --bootstrap-server $KAFKA_BROKER --create --if-not-exists \
  --topic magdef-service-logs --replication-factor 1 --partitions 100

kafka-topics --bootstrap-server $KAFKA_BROKER --create --if-not-exists \
  --topic magdef-registered-services --replication-factor 1 --partitions 3

echo "Registering schemas..."

for TOPIC in magdef.service-logs magdef.registered-services; do
  curl -X POST "$SCHEMA_REGISTRY_URL/subjects/$TOPIC-value/versions" \
    -H "Content-Type: application/vnd.schemaregistry.v1+json" \
    -d "{\"schema\": $(jq -Rs . < /schemas/$TOPIC.avsc)}"
done

echo "Done initializing Kafka topics and schemas."