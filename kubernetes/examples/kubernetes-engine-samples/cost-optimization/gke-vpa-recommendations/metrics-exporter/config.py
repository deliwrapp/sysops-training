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
import os
import utils
from google.cloud import monitoring_v3


class MetricConfig:
    """
    A configuration class for metric data.

    :param metric: The name of the metric.
    :param window: The window of time for the metric.
    :param seconds_between_points: The interval between metric points.
    :param data_type: The type of the metric data.
    :param per_series_aligner: The aligner for the metric data series.
    :param cross_series_reducer: The reducer for the metric data series.
    :param columns: The columns to be included in the metric data.
    """

    def __init__(
            self,
            metric: str,
            window: int,
            seconds_between_points: int,
            data_type: str,
            per_series_aligner: monitoring_v3.types.Aggregation.Aligner,
            cross_series_reducer: monitoring_v3.types.Aggregation.Reducer,
            columns: [str]):
        self.metric = metric
        self.window = window
        self.seconds_between_points = seconds_between_points
        self.per_series_aligner = per_series_aligner
        self.cross_series_reducer = cross_series_reducer
        self.data_type = data_type
        self.columns = columns

PROJECT_ID = utils.get_gcp_project_id()

BIGQUERY_DATASET = os.getenv("BIGQUERY_DATASET", "gke_metrics_dataset")
BIGQUERY_TABLE = os.getenv("BIGQUERY_TABLE", "gke_metrics")
TABLE_ID = f'{PROJECT_ID}.{BIGQUERY_DATASET}.{BIGQUERY_TABLE}'

RECOMMENDATION_WINDOW_SECONDS = int(
    os.getenv("RECOMMENDATION_WINDOW_SECONDS", '2592000'))
LATEST_WINDOW_SECONDS = int(os.getenv("LATEST_WINDOW_SECONDS", '300'))
METRIC_WINDOW = int(os.getenv("METRIC_WINDOW", '259200'))
METRIC_DISTANCE = int(os.getenv("METRIC_DISTANCE", '600'))
RECOMMENDATION_DISTANCE = int(os.getenv("RECOMMENDATION_DISTANCE", "86400"))

gke_group_by_fields = [
    'resource.label."location"',
    'resource.label."project_id"',
    'resource.label."cluster_name"',
    'resource.label."controller_name"',
    'resource.label."namespace_name"',
    'resource.label."container_name"',
    'metadata.system_labels."top_level_controller_name"',
    'metadata.system_labels."top_level_controller_type"']
hpa_group_by_fields = [
    'resource.label."location"',
    'resource.label."project_id"',
    'resource.label."cluster_name"',
    'resource.label."namespace_name"',
    'metric.label."container_name"',
    'metric.label."targetref_kind"',
    'metric.label."targetref_name"']
scale_group_by_fields = [
    'resource.label."location"',
    'resource.label."project_id"',
    'resource.label."cluster_name"',
    'resource.label."namespace_name"',
    'metric.label."container_name"',
    'resource.label."controller_kind"',
    'resource.label."controller_name"']

excluded_namespaces = [
    "kube-system",
    "istio-system",
    "gatekeeper-system",
    "gke-system",
    "gmp-system",
    "gke-gmp-system",
    "gke-managed-filestorecsi",
    "gke-mcs"]

namespace_filter = ' AND '.join(
    f'NOT resource.label.namespace_name = "{namespace}"' for namespace in excluded_namespaces)

NS_QUERY = MetricConfig(
    metric="kubernetes.io/container/cpu/core_usage_time",
    window=METRIC_WINDOW,
    seconds_between_points=METRIC_DISTANCE,
    per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_NONE,
    cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_COUNT,
    data_type="double_value",
    columns=['resource.labels.namespace_name']
)

MQL_QUERY = {
    "cpu_usage": MetricConfig(
        metric="kubernetes.io/container/cpu/core_usage_time",
        window=METRIC_WINDOW,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_RATE,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_PERCENTILE_95,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "cpu_requested_cores": MetricConfig(
        metric="kubernetes.io/container/cpu/request_cores",
        window=LATEST_WINDOW_SECONDS,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MEAN,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MEAN,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "cpu_limit_cores": MetricConfig(
        metric="kubernetes.io/container/cpu/limit_cores",
        window=LATEST_WINDOW_SECONDS,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MEAN,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MEAN,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "cpu_request_utilization": MetricConfig(
        metric="kubernetes.io/container/cpu/request_utilization",
        window=METRIC_WINDOW,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MAX,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MAX,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "memory_usage": MetricConfig(
        metric="kubernetes.io/container/memory/used_bytes",
        window=METRIC_WINDOW,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MAX,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MAX,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "memory_requested_bytes": MetricConfig(
        metric="kubernetes.io/container/memory/request_bytes",
        window=LATEST_WINDOW_SECONDS,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MEAN,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MEAN,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "memory_limit_bytes": MetricConfig(
        metric="kubernetes.io/container/memory/limit_bytes",
        window=LATEST_WINDOW_SECONDS,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MEAN,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MEAN,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "memory_request_utilization": MetricConfig(
        metric="kubernetes.io/container/memory/request_utilization",
        window=METRIC_WINDOW,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MAX,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MAX,
        data_type="double_value",
        columns=gke_group_by_fields
    ),
    "hpa_cpu": MetricConfig(
        metric="custom.googleapis.com/podautoscaler/hpa/cpu/target_utilization",
        window=LATEST_WINDOW_SECONDS,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MEAN,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MEAN,
        data_type="int64_value",
        columns=hpa_group_by_fields
    ),
    "hpa_memory": MetricConfig(
        metric="custom.googleapis.com/podautoscaler/hpa/memory/target_utilization",
        window=LATEST_WINDOW_SECONDS,
        seconds_between_points=METRIC_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MEAN,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MEAN,
        data_type="int64_value",
        columns=hpa_group_by_fields
    ),
    "vpa_memory_recommendation": MetricConfig(
        metric="kubernetes.io/autoscaler/container/memory/per_replica_recommended_request_bytes",
        window=RECOMMENDATION_WINDOW_SECONDS,
        seconds_between_points=RECOMMENDATION_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MAX,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MAX,
        data_type="double_value",
        columns=scale_group_by_fields
    ),
    "vpa_cpu_recommendation": MetricConfig(
        metric="kubernetes.io/autoscaler/container/cpu/per_replica_recommended_request_cores",
        window=RECOMMENDATION_WINDOW_SECONDS,
        seconds_between_points=RECOMMENDATION_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MEAN,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_PERCENTILE_95,
        data_type="double_value",
        columns=scale_group_by_fields
    ),
    "vpa_cpu_recommendation_max": MetricConfig(
        metric="kubernetes.io/autoscaler/container/cpu/per_replica_recommended_request_cores",
        window=RECOMMENDATION_WINDOW_SECONDS,
        seconds_between_points=RECOMMENDATION_DISTANCE,
        per_series_aligner=monitoring_v3.types.Aggregation.Aligner.ALIGN_MAX,
        cross_series_reducer=monitoring_v3.types.Aggregation.Reducer.REDUCE_MAX,
        data_type="double_value",
        columns=scale_group_by_fields
    )
}
