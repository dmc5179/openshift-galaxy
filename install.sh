#!/bin/bash

oc new-project galaxy
oc project galaxy
oc adm policy add-scc-to-user anyuid -z default

# Create service accounts
oc apply -f 00-serviceaccount.yaml 


# Create image streams
oc apply -f galaxy-api-imagestream.yaml
oc apply -f galaxy-celery-beat-imagestream.yaml
oc apply -f galaxy-celery-worker-imagestream.yaml
oc apply -f galaxy-pulp-rm-imagestream.yaml
oc apply -f galaxy-pulp-worker-imagestream.yaml
oc apply -f galaxy-ui-imagestream.yaml
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


# Deploy the galaxy API
oc apply -f galaxy-api-deploymentconfig.yaml
oc rollout status dc/galaxy-api
oc apply -f galaxy-api-service.yaml


# Create deployments
# FAILING doesn't like redis name
oc apply -f galaxy-pulp-worker-deploymentconfig.yaml
oc rollout status dc/galaxy-pulp-worker

# FAILING doesn't like redis name
oc apply -f galaxy-pulp-rm-deploymentconfig.yaml
oc rollout status dc/galaxy-pulp-rm

# WORKING
oc apply -f galaxy-celery-worker-deploymentconfig.yaml
oc rollout status dc/galaxy-celery-worker

# FAILING, who knows why....
oc apply -f galaxy-celery-beat-deploymentconfig.yaml
oc rollout status dc/galaxy-celery-beat

oc apply -f galaxy-ui-deploymentconfig.yaml
oc rollout status dc/galaxy-ui

# Create UI service
oc apply -f galaxy-ui-service.yaml

# Create UI route
oc expose svc/galaxy-ui
