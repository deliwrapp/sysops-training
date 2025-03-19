### Summary
This is an adaptation of the HuggingFace training example https://huggingface.co/docs/transformers/tasks/image_classification which showcases how to deploy the notebook in GKE and leverage storage like Filestore to accelerate the training.


### Pre-requisites
1. Quota for GPUs (https://cloud.google.com/kubernetes-engine/docs/concepts/gpus#gpu-quota).The default example deploys a 1 node with L4 GPU
2. Minimum 10Ti quota (`HighScaleSSDStorageGibPerRegion`) for Filestore highscale tier (https://cloud.google.com/filestore/docs/service-tiers)

## Prepare GKE Infra
 For easy one click deploy, a terraform template has been provided which deploys a GKE cluster with GPU node pool. Additionally the terraform also sets up the [GKE Filestore](https://cloud.google.com/filestore/docs/csi-driver), [GKE GCS Fuse](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver) CSI drivers

> **NOTE:**
> 1. Update the "project_id" in [variables.tf](tf/platform/variables.tf) to your project name

```
 $ cd tf/platform
 $ terraform init
 $ terraform apply
```
 
 > **NOTE:** After terraform apply steps complete successfully, setup the kubeconfig credentials
 `gcloud container clusters get-credentials ml-vit-luster --zone=us-central1-c`

## Prepare GCS specific infra
 This step is needed only to deploy the Jupyter [pod spec](yamls/spec-gcs.yaml) which mounts GCS Buckets using [GKE GCS Fuse](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver) CSI Driver. For trying out only Filestore based [example](yamls/spec-filestore.yaml), this section can be skipped
 
 1. Setup GCS specific env variables for ease of use
 ```
 GCS_BUCKET_NAME=<your-bucket-name>
 
 GCS_GCP_SA=<your-gcp-sa-name> # this is the GCP service account to prepare the [WorkloadIdentity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) bindings so that the k8s pod can access the bucket
 
 GCSFUSE_KSA=<your-k8s-sa-name> # this is k8s service account which binds to the GCP SA
 
 gcloud storage buckets create gs://$GCS_BUCKET_NAME

 ```
 
 2. Ensure the same names are setup for the variables "service_account" (=GCS_GCP_SA), "k8s_service_account" (=GCSFUSE_KSA), "gcs_bucket" (=GCS_BUCKET_NAME) in [user/variables.tf](tf/user/variables.tf)
 ```
 $ cd tf/user
 $ terraform init
 $ terraform apply
 ```

After terraform apply steps complete successfully, the desired service account bindings are created. The terraform automates the steps documented [here](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/cloud-storage-fuse-csi-driver#authentication)

## Deploy workloads

### Deploy Jupyter Pod using GCS Buckets

1.  Replace the GCS_BUCKET_NAME and GCSFUSE_KSA variables
```
sed -i "s/<GCS_BUCKET_NAME>/$GCS_BUCKET_NAME/g" yamls/spec-gcs.yaml
sed -i "s/<GCSFUSE_KSA>/$GCSFUSE_KSA/g" ./spec-gcs.yaml
```

2. Deploy the [podspec](yamls/spec-gcs.yaml)
```
kubectl apply -f yamls/spec-gcs.yaml
```

3. Setup the context for the namespace (this is the namespace created by terraform based on the "namespace" variable in [user/variables.tf](tf/user/variables.tf))

```
kubectl config set-context --current --namespace example
```

4. Verify jupyter pod is up and running and fetch the LB Ip and the necessary token
```
$ kubectl get all
NAME               READY   STATUS    RESTARTS   AGE
pod/tensorflow-0   2/2     Running   0          77m

NAME                         TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
service/tensorflow           ClusterIP      None          <none>          8888/TCP       77m
service/tensorflow-jupyter   LoadBalancer   10.8.17.169   35.224.15.129   80:32731/TCP   77m

NAME                          READY   AGE
statefulset.apps/tensorflow   1/1     77m


$ kubectl exec --tty -i tensorflow-0 -c tensorflow-container -n example -- jupyter notebook list
Currently running servers:
http://0.0.0.0:8888/?token=<hash> :: /tf
```

4. In your web browser use the external IP of the tensorflow-jupyter service and login to the notebook using the token


### Deploy Jupyter Pod using Filestore

1. Deploy the [podspec](yamls/spec-filestore.yaml)
```
kubectl apply -f yamls/spec-gcs.yaml
```

2. Setup the context for the namespace (this is the namespace created by terraform based on the "namespace" variable in [user/variables.tf](tf/user/variables.tf))

```
kubectl config set-context --current --namespace example
```

3. Verify jupyter pod is up and running and fetch the LB Ip and the necessary token
```
$ kubectl get all
NAME               READY   STATUS    RESTARTS   AGE
pod/tensorflow-0   2/2     Running   0          77m

NAME                         TYPE           CLUSTER-IP    EXTERNAL-IP     PORT(S)        AGE
service/tensorflow           ClusterIP      None          <none>          8888/TCP       77m
service/tensorflow-jupyter   LoadBalancer   10.8.17.169   35.224.15.129   80:32731/TCP   77m

NAME                          READY   AGE
statefulset.apps/tensorflow   1/1     77m


$ kubectl exec --tty -i tensorflow-0 -c tensorflow-container -n example -- jupyter notebook list
Currently running servers:
http://0.0.0.0:8888/?token=<hash> :: /tf
```

4. In your web browser use the external IP of the tensorflow-jupyter service and login to the notebook using the token

### Run the notebook
The notebook which runs the training can be found [here](notebooks/ViTClassfication-v1.ipynb)

## Teardown

1. teardown the SA, bindings
```
$ cd tf/user
$ terraform destroy
```

2. teardown the cluster
```
$ cd tf/user
$ terraform destroy
```