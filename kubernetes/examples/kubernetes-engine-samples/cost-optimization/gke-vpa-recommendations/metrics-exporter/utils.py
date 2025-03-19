import config
import json
import logging
import os
import sys
import urllib.request
from google.cloud import monitoring_v3
from stackdriver_log_formatter import StackdriverLogFormatter

logger = logging.getLogger(__name__)


def get_interval(now, window):
    seconds = int(now)
    nanos = int((now - seconds) * 10 ** 9)

    interval = monitoring_v3.TimeInterval(
        {
            "end_time": {"seconds": seconds, "nanos": nanos},
            "start_time": {"seconds": (seconds - window), "nanos": nanos},
        }
    )

    return interval


def get_aggregation(query):
    aggregation = monitoring_v3.Aggregation(
        {
            "alignment_period": {"seconds": query.seconds_between_points},
            "per_series_aligner": query.per_series_aligner,
            "cross_series_reducer": query.cross_series_reducer,
            "group_by_fields": query.columns,
        }
    )

    return aggregation


def get_request_name():
    project_name = f"projects/{config.PROJECT_ID}"
    return project_name


def get_gcp_project_id():
    project_id = os.environ.get("PROJECT_ID", None)

    if not project_id:
        project_id = get_project_id()

    if not project_id:  # Running locally
        with open(os.environ["GOOGLE_APPLICATION_CREDENTIALS"], "r") as fp:
            credentials = json.load(fp)
        project_id = credentials["project_id"]

    if not project_id:
        logger.error(
            "Unable to detect GCP project id, please set the 'PROJECT_ID' environment variable.")
        raise ValueError("Could not get a value for PROJECT_ID")

    return project_id


def get_project_id():
    project_id = None

    url = "http://metadata.google.internal/computeMetadata/v1/project/project-id"
    req = urllib.request.Request(url)
    req.add_header("Metadata-Flavor", "Google")

    try:
        project_id = urllib.request.urlopen(req, timeout=1).read().decode()
    except Exception as e:
        logger.debug(
            f"Metadata service failed, not deployed in GCP. Returning None, {e}")

    return project_id


def is_deployed():
    id_from_metadata = get_project_id()

    if id_from_metadata is not None:
        r_val = True
    else:
        r_val = False

    return r_val


def setup_logging():  # pragma: no cover
    logging_level = os.environ.get('LOGGING_LEVEL', "info").upper()

    handler = logging.StreamHandler(sys.stdout)

    if is_deployed():
        handler.setFormatter(StackdriverLogFormatter())

    logging.basicConfig(
        level=logging_level,
        format="%(asctime)s [%(threadName)-12.12s] [%(levelname)-5.5s]  %(message)s",
        handlers=[handler])
