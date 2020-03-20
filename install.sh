#!/bin/bash

oc new-project galaxy
oc project galaxy
oc adm policy add-scc-to-user anyuid -z default

# Create service accounts
oc apply -f 00-serviceaccount.yaml 

# Create image streams
oc apply -f galaxy-dev-imagestream.yaml
oc apply -f influxdb-imagestream.yaml
oc apply -f postgres-imagestream.yaml
oc apply -f rabbitmq-imagestream.yaml
oc apply -f redis-imagestream.yaml

# Create Persistent Volume Claims
oc apply -f postgres-pvc.yaml

# Roll out initial services which do not depend
# on other services
oc apply -f redis-deploymentconfig.yaml
oc apply -f rabbitmq-deploymentconfig.yaml
oc apply -f influxdb-deploymentconfig.yaml
oc apply -f postgres-deploymentconfig.yaml

# Wait for the services to finish deployment
oc rollout status dc/redis
oc rollout status dc/rabbitmq
oc rollout status dc/influxdb
oc rollout status dc/postgres

# Deploy services for current deployments
oc apply -f influxdb-service.yaml
oc apply -f postgres-service.yaml
oc apply -f rabbitmq-service.yaml
oc apply -f redis-service.yaml

# Deploy Galaxy
oc apply -f galaxy-dev-deploymentconfig.yaml

# Deploy Galaxy Service
oc apply -f galaxy-dev-imagestream.yaml

# Expose Galaxy
oc expose svc/galaxy-dev
