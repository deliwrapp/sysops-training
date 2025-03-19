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
POD_ORDINAL_START=${1:-0}
POD_ORDINAL_END=${2:-2}
for i in $(seq ${POD_ORDINAL_START} ${POD_ORDINAL_END}); do
  echo "Configuring pod mysql1/dbc1-${i}"
  cat <<'  EOF' | kubectl -n mysql1 exec -i dbc1-${i} -- bash -c 'mysql -uroot -proot --password=${MYSQL_ROOT_PASSWORD}'
INSTALL PLUGIN group_replication SONAME 'group_replication.so';
RESET PERSIST IF EXISTS group_replication_ip_allowlist;
RESET PERSIST IF EXISTS binlog_transaction_dependency_tracking;
SET @@PERSIST.group_replication_ip_allowlist = 'mysql.mysql1.svc.cluster.local';
SET @@PERSIST.binlog_transaction_dependency_tracking = 'WRITESET';
  EOF
done
# [END gke_stateful_mysql_main_body]
