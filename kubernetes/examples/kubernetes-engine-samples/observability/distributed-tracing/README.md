# Distributed Tracing example

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/kubernetes-engine-samples&cloudshell_tutorial=cloudshell/tutorial.md&cloudshell_workspace=distributed-tracing)

This example shows how to build and deploy a containerized Go web server
instrumented with [OpenTelemetry](https://opentelemetry.io) to a
[Kubernetes](https://kubernetes.io) cluster.

Visit https://cloud.google.com/architecture/using-distributed-tracing-to-observe-microservice-latency-with-opencensus-and-stackdriver-trace
to follow the tutorial and deploy this application on [Google Kubernetes
Engine](https://cloud.google.com/kubernetes-engine).

This directory contains:

- `main.go` contains the HTTP server implementation, which is instrumented with
  OpenTelemetry. It responds to all HTTP requests by making an outbound HTTP
  GET request to a destination URL.
- `Dockerfile` is used to build the Docker image for the application.
- `backend-deployment.yaml` is used to deploy the application so that it makes
  a request to google.com when it receives a request.
- `frontend-deployment.yaml` is used to deploy the application so that it makes
  a request to the backend deployment.
