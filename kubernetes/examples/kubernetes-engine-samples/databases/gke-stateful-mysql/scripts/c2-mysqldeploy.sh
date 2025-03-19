#!/bin/bash
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License .

echo "Deploying secondary MySQL cluster"
echo "Creating namespace mysql2 for secondary cluster use"
kubectl create namespace mysql2
echo "..."
echo "Create secret configuration in namespace mysql2 for secondary cluster use"
kubectl apply -n mysql2 -f ../kubernetes/secret.yaml
echo "..."
echo "Create storage in namespace mysql2 for secondary cluster use"
kubectl apply -n mysql2 -f ../kubernetes/storageclass.yaml
echo "..."
echo "Create MySQL statefulset in namespace mysql2 for secondary cluster use"
kubectl apply -n mysql2 -f ../kubernetes/c2-mysql.yaml
echo "..."
echo "use kubectl get pods -n mysql2 --watch to view progress before moving to the next step"

