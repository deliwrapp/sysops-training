# Stateful workload with Filestore tutorial

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/kubernetes-engine-samples&cloudshell_tutorial=README.md&cloudshell_workspace=guestbook/)

Please follow the tutorial at https://cloud.google.com/kubernetes-engine/docs/tutorials/stateful-workload.

## Design

This tutorial will create writer Deployments that write to the NFS (Network File System) — specifically, Google Cloud [Filestore](https://cloud.google.com/filestore) — and create reader Deployments that will read from the same file in NFS. The user can then access the reader externally to see the changes the writer made to the file.
Technologies used in this tutorial:
- Google Kubernetes Engine (GKE)
- Google Cloud Filestore (used as NFS)

## Multiple/concurrent access to persistent data

- This tutorial will use NFS (Google Cloud Filestore) as a way to showcase scalable stateful workloads and allow ReadWriteMany access mode for PV ([Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)) and PVC ([PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)).
- The writer is a Deployment workload
    - Each Pod has access to write to the NFS that is mounted
    - Each Pod will write the current time and name of the Pod to a shared file with other writers and readers
    - The writer has a script that will write to this file every 30 seconds indefinitely (time interval configurable)
    - Showcase ReadWriteMany by having more than 2 Pods writing at the same time
- The reader workload is a Deployment, that is exposed externally via a Service of type `LoadBalancer`.
    - The reader can, at a glance, see the history of writers that are actively writing to the file
    - The reader only has read access

## Scalability
- The reader/writer Deployments can be easily scaled up or down, while maintaining connection to the shared FileStore NFS with ReadWriteMany access
- Start with 2 writer Pods, then scale up to 5 Pods to showcase scalability with NFS
The user will be able to see 5 different writers all writing to the same file