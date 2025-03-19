echo "Create a new IAM service account"
gcloud iam service-accounts create svc-metric-exporter \
    --project=${PROJECT_ID}

echo "Creating a gke cluster"
gcloud container clusters create online-boutique \
    --project=${PROJECT_ID} --zone=${ZONE} \
    --enable-shielded-nodes \
    --shielded-secure-boot \
    --shielded-integrity-monitoring \
    --service-account=svc-metric-exporter@${PROJECT_ID}.iam.gserviceaccount.com \
    --machine-type=e2-standard-2 --num-nodes=5 \
    --workload-pool=${PROJECT_ID}.svc.id.goog

sleep 7 &
PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
done

echo "Get credentials for your cluster"
gcloud container clusters get-credentials online-boutique

echo "Granting roles..."
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:svc-metric-exporter@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/monitoring.metricWriter"

gcloud projects add-iam-policy-binding  $PROJECT_ID \
    --member="serviceAccount:svc-metric-exporter@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/compute.viewer"

gcloud projects add-iam-policy-binding  $PROJECT_ID \
    --member="serviceAccount:svc-metric-exporter@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.reader"

gcloud projects add-iam-policy-binding  $PROJECT_ID \
    --member="serviceAccount:svc-metric-exporter@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/container.nodeServiceAgent"

gcloud iam service-accounts add-iam-policy-binding svc-metric-exporter@${PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:${PROJECT_ID}.svc.id.goog[custom-metrics/metrics-exporter-sa]"


echo "deploy the onlineshop"
kubectl apply -f k8s/online-shop.yaml

echo "To simulate a more realistic environment, create an HPA for Online Boutique deployments"
kubectl autoscale deployment adservice --cpu-percent=70 --min=2 --max=100

kubectl get hpa

kubectl create ns custom-metrics


echo "SETUP COMPLETE"