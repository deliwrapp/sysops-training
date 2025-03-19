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
# limitations under the License.
# [START gke_stateful_mysql_main_body]
NAMESPACE=${1:+"-n ${1}"}
shift
APP_SELECTOR=${1:+"--selector=app=${1}"}
shift

# jsonpath will iterate through each of the pods 
# and output Pod name and node name
for EACH_POD_NODE in `kubectl \
                       --field-selector status.phase!=Pending \
                       ${NAMESPACE} get pods ${APP_SELECTOR} \
                       -o=jsonpath='{range .items[*]}{.metadata.name}{","}{.spec.nodeName}{"\n"}{end}' `
do
  # for each Pod/Node line item, obtain Cloud Zone for Node
  IFS=","; POD_NODE=($EACH_POD_NODE)
  kubectl get node ${POD_NODE[1]} \
     -o jsonpath='{.metadata.name} {.metadata.labels.topology\.kubernetes\.io\/zone} {"'${POD_NODE[0]}'"}{"\n"}'
done
# [END gke_stateful_mysql_main_body]
