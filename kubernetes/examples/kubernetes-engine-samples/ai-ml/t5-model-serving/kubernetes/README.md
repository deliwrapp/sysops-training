# Kubernetes Manifests

This directory contains manifests to deploy `torchserve` inference server with prepared T5 model and Client Application.

Manifests were tested against GKE Autopilot Kubernetes cluster.

## HPA

To configure HPA base on metrics from `torchserve` you need to:

* Enable [Google Manager Prometheus](https://cloud.google.com/stackdriver/docs/managed-prometheus) or install OSS Prometheus.
* Install [Custom Metrics Adapter](https://github.com/GoogleCloudPlatform/k8s-stackdriver/tree/master/custom-metrics-stackdriver-adapter).
* Apply `pod-monitoring.yaml` and `hpa.yaml`
