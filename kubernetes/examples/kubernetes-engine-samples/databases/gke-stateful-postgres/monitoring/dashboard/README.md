# Setup Prometheus Dashboard for Postgresql

## Key steps:
* Deploy GMP (Google Managed Prometheus) by Helm
* Config scrape for PostgreSQL as ServiceMonitor
* Create monitoring dashboard from a json file by bash script

## Prerequisites:
* The workload Postgres is ready with data
  Refer to `01-Setup.md` to setup the environment

## Provision GMP (Google Managed Prometheus)
Refer to `<ROOT>/monitoring/helm/monitoring-stack-bootstrap/README.md` to setup the monitoring stack, then verify the status by metric `pg_up` via PromQL on the console of GCP Monitoring. 
```
cd monitoring/helm/monitoring-stack-bootstrap
helm -n monitoring upgrade --install monitoring-stack ./ 
```

## Add Postgres Exporter 
```
# push image
bash scripts/gcr.sh bitnami/postgres-exporter 0.11.0-debian-11-r1

# deploy the exporter
cd helm/postgresql-bootstrap
helm -n postgresql upgrade postgresql ./ 
```

## Create a dashboard for PostgreSQL
Use the provided script to create a dashboard.
```
export SOURCE_CLUSTER=cluster-db1
export NAMESPACE=postgresql
kubectx $SOURCE_CLUSTER
export FILE_NAME=dashboard/postgresql-overview.json
bash scripts/dashboard.sh import $PROJECT_ID $FILE_NAME
```

## Full list of all available metrics for PostgreSQL 
`metrics-primary-all.txt` Having a full list of all available metrics in a local file, you can easily understand the meaning of each metric from the comment lines and pick up the metrics you need to tailor into the dashboard. 