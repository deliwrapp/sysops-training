#!/bin/bash
# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o pipefail

# Setup variables

CLI_NAME=${0}
OPTIONS=$(getopt -o n:l:ih --long namespace:,level:,include-kube-system,help -- "$@")
EXCLUSIONS="--field-selector metadata.namespace!=kube-system"

eval set -- ${OPTIONS}

# Setup options

while true; do
  case "$1" in
    -n|--namespace)
      NAMESPACE="$2"
      shift 2
      ;;
    -l|--level)
      LEVEL="$2"
      shift 2
      ;;
    -i|--include-kube-system)
      INCLUDE_KUBE_SYSTEM=true
      EXCLUSIONS=""
      shift 1
      ;;
    -h|--help)
      cat << USAGE

kube-requests-checker - Show containers without requests set for CPU, Memory, or both, in a Kubernetes cluster

Usage: ${CLI_NAME} <options>

-n | --namespace <namespace>   : Check containers in one specific namespace                                     Default: All non "kube-system" namespaces
-l | --level <level>           : Group results by "pod" or "controller". "pod" also returns Pod QoS.            Default: controller
-i | --include-kube-system     : Include "kube-system" namespace. Cannot be used when specifying one namespace.                                   
-h | --help                    : Show CLI usage

Example:
========
Show all containers with no requests set in the cluster in all non kube-system namespaces.                      $ ${CLI_NAME}
Show all containers with no requests set in the cluster, in all namespaces, including kube-system.              $ ${CLI_NAME} -i
Show all containers with no requests set in namespace foo, and group by pod.                                    $ ${CLI_NAME} -n foo -l pod


USAGE
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Invalid option: '$1' - run ${CLI_NAME} -h for help."
      exit 1
      ;;    
  esac
done

# Validate namespace usage

if [ -v NAMESPACE ] && [ -v INCLUDE_KUBE_SYSTEM ]; then
   echo "Invalid option: 'namespace' (-n) and 'include-kube-system' (-i) cannot be specified simultaneously." 1>&2
   exit 1
fi

# Set namespace

if [ -v NAMESPACE ]; then
    NAMESPACE="-n=${NAMESPACE}"
    EXCLUSIONS=""
else
    NAMESPACE="--all-namespaces"
fi

# Set level and get containers from pods/controller objects

if [ "${LEVEL}" = "pod" ]; then
    json=$(kubectl get pods ${NAMESPACE} ${EXCLUSIONS} \
            -o json | \
            jq '[.items[] | {kind: .kind, namespace: .metadata.namespace, name: .metadata.name, podQoS: .status.qosClass, containers: [ .spec.containers[] | {name: .name, cpuRequest: .resources.requests.cpu, cpuLimit: .resources.limits.cpu, memRequest: .resources.requests.memory, memLimit: .resources.limits.memory}]}]')
else
    if [ "${LEVEL}" = "" ]; then
        LEVEL="controller"
    elif [ "${LEVEL}" = "controller" ]; then
        true
    else
       echo "Invalid option: '${LEVEL}' is not valid. Must be 'pod' or 'controller'."
       exit 1
    fi
    json=$(kubectl get deployments,daemonsets,statefulset,jobs ${NAMESPACE} ${EXCLUSIONS} \
            -o json | \
            jq '[.items[] | {kind: .kind, namespace: .metadata.namespace, name: .metadata.name, containers: [ .spec.template.spec.containers[] | {name: .name, cpuRequest: .resources.requests.cpu, cpuLimit: .resources.limits.cpu, memRequest: .resources.requests.memory, memLimit: .resources.limits.memory}]}]')
fi

# Return containers and QoS for Pod

echo "---------------------------------------------------------------------------------"
echo "Running analysis for containers without requests:"
echo "  - namespace: ${NAMESPACE} ${EXCLUSIONS}"
echo "  - level: ${LEVEL}"
echo "---------------------------------------------------------------------------------"

printf "\n"
for obj in $(jq -c '.[]' <<< "$json"); do
    containers=$(echo $obj | jq .containers)
    besteffort=""
    for container in  $(jq -c '.[]' <<< "$containers"); do                
        if jq -e '(.cpuRequest==null and .cpuLimit==null) or (.memRequest==null and .memLimit==null)' <<< "$container" >/dev/null; then
            besteffort+="\n   - $(echo $container | jq .name): CPU($(echo $container | jq -e '.cpuRequest==null and .cpuLimit==null')) & MEM($(echo $container | jq -e '.memRequest==null and .memLimit==null'))"
        fi
    done
    if [ -n "$besteffort" ]; then
        printf "$(echo $obj | jq .kind): $(echo $obj | jq .namespace).$(echo $obj | jq .name) has containers without requests: $besteffort.\n"
        if [ "${LEVEL}" = "pod" ]; then
            printf "This Pod runs with $(echo $obj | jq .podQoS) quality of service.\n\n"
        fi
    fi
done