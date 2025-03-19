/*
# Copyright 2023 Google Inc.
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
*/
WITH
  data_deduped AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY run_date, metric_name, project_id, location, cluster_name, namespace_name, controller_name, container_name ORDER BY run_date DESC) AS rn
  FROM
    `${project_id}.${table_dataset}.${table_id}` ),
flattened AS (SELECT
  DATE(TIMESTAMP_TRUNC(TIMESTAMP(run_date), DAY)) AS run_date,
  location,
  project_id,
  cluster_name,
  controller_name,
  controller_type,
  namespace_name,
  container_name,
  metric_name,
  points.metric_timestamp,
  points.metric_value
FROM
  data_deduped,
  UNNEST(points_array) AS points WHERE rn = 1
),
aggregate AS (
  SELECT
  run_date,
  location,
  project_id,
  cluster_name,
  controller_name,
  controller_type,
  namespace_name,
  container_name,
  metric_name,
  CASE
    WHEN metric_name = "cpu_usage" THEN PERCENTILE_CONT(metric_value, 0.95) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "cpu_requested_cores" THEN AVG(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "cpu_limit_cores" THEN AVG(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "cpu_request_utilization" THEN MAX(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "vpa_cpu_recommendation" THEN PERCENTILE_CONT(metric_value, 0.95) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "vpa_cpu_recommendation_max" THEN PERCENTILE_CONT(metric_value, 0.95) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "memory_usage" THEN MAX(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "memory_requested_bytes" THEN AVG(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "memory_limit_bytes" THEN AVG(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "memory_request_utilization" THEN MAX(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
    WHEN metric_name = "vpa_memory_recommendation" THEN MAX(metric_value) OVER(PARTITION BY metric_name, project_id, location, cluster_name, controller_name, controller_type, namespace_name, container_name , run_date)
  END as agg_value
FROM flattened
), staging AS (
SELECT 
  run_date,
  location,
  project_id,
  cluster_name,
  controller_name,
  controller_type,
  namespace_name,
  container_name,
  # CPU METRICS
  MAX(CASE WHEN metric_name = 'cpu_usage'  THEN agg_value * 1000 ELSE 0 END) AS cpu_mcore_usage,
  MAX(CASE WHEN metric_name = 'cpu_requested_cores'  THEN ROUND(agg_value * 1000,0) ELSE 0 END) AS cpu_requested_mcores,
  MAX(CASE WHEN metric_name = 'cpu_limit_cores'  THEN ROUND(agg_value * 1000,0) ELSE 0 END) AS cpu_limit_mcores,
  MAX(CASE WHEN metric_name = 'cpu_request_utilization' THEN agg_value ELSE 0 END) AS cpu_request_utilization,
  MAX(CASE WHEN metric_name = 'vpa_cpu_recommendation'  THEN ROUND(agg_value * 1000,0) ELSE 0 END) AS cpu_vpa_rec_95th,
  MAX(CASE WHEN metric_name = 'vpa_cpu_recommendation_max'  THEN ROUND(agg_value * 1000,0) ELSE 0 END) AS cpu_vpa_rec,
  # MEMORY METRICS
  MAX(CASE WHEN metric_name = 'memory_usage' THEN agg_value/1024/1024  ELSE 0 END) AS memory_mib_usage_max,
  MAX(CASE WHEN metric_name = 'memory_requested_bytes' THEN ROUND(agg_value/1024/1024, 0) ELSE 0 END) AS memory_requested_mib,
  MAX(CASE WHEN metric_name = 'memory_limit_bytes' THEN ROUND(agg_value/1024/1024,0)  ELSE 0 END)AS memory_limit_mib,
  MAX(CASE WHEN metric_name = 'memory_request_utilization' THEN agg_value ELSE 0 END) AS memory_request_utilization,
  MAX(CASE WHEN metric_name = 'vpa_memory_recommendation' THEN ROUND(agg_value/1024/1024, 0)  ELSE 0 END) AS memory_vpa_rec

FROM aggregate
GROUP BY 1,2,3,4,5,6,7,8
), recommendation_staging AS (
SELECT
*,
  CEIL(CASE
        WHEN controller_type = 'Deployment' THEN (IF((cpu_requested_mcores = cpu_limit_mcores ), (cpu_vpa_rec + SAFE_DIVIDE( cpu_vpa_rec, 30)), (cpu_vpa_rec_95th + SAFE_DIVIDE(cpu_vpa_rec_95th, 30 ))))
      ELSE
      cpu_mcore_usage + SAFE_DIVIDE(cpu_mcore_usage, 30)
    END
      ) AS cpu_requested_recommendation,
  CEIL(CASE
        WHEN controller_type = 'Deployment' THEN (memory_vpa_rec + SAFE_DIVIDE( memory_vpa_rec , 20 ))
      ELSE
      memory_mib_usage_max + SAFE_DIVIDE(memory_mib_usage_max , 20 )
    END
      ) AS memory_requested_recommendation, 
FROM staging )
SELECT
    run_date,
    project_id,
    location,
    cluster_name,
    controller_name,
    controller_type,
    namespace_name,
    container_name,
    cpu_mcore_usage,
    memory_mib_usage_max,
    cpu_requested_mcores,
    cpu_limit_mcores,
    cpu_request_utilization,
    memory_requested_mib,
    memory_limit_mib,
    memory_request_utilization,
    cpu_requested_recommendation,
  GREATEST((CASE
    WHEN cpu_limit_mcores = 0 AND cpu_requested_mcores = 0 THEN CEIL(cpu_requested_recommendation)
    WHEN cpu_limit_mcores = 0 AND cpu_requested_mcores > 0 THEN CEIL(cpu_requested_recommendation)
    WHEN cpu_limit_mcores > 0 AND cpu_requested_mcores = 0 THEN CEIL(cpu_requested_recommendation)
  ELSE
  CEIL(cpu_requested_recommendation * SAFE_DIVIDE(cpu_limit_mcores, cpu_requested_mcores))
END), CEIL(cpu_mcore_usage))
  AS cpu_limit_recommendation,
  CEIL(GREATEST(memory_requested_recommendation, memory_mib_usage_max)) AS memory_requested_recommendation,
  CEIL(GREATEST(memory_requested_recommendation, memory_mib_usage_max)) AS memory_limit_recommendation,
  ((cpu_requested_mcores-cpu_requested_recommendation) + ((memory_requested_mib - memory_requested_recommendation)/13.4)) AS priority
FROM
  recommendation_staging ORDER BY run_date
