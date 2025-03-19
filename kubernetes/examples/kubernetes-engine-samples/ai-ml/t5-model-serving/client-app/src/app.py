#!/usr/bin/env python3

# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import logging
from fast_dash import FastDash
import requests
from os import environ

logger = logging.getLogger(__name__)

MANAGEMENT_URL = environ.get('MODEL_MANAGEMENT', 'http://localhost:8081/models/t5-small')
PREDICTION_URL = environ.get('MODEL_PREDICTION', 'http://localhost:8080/predictions/t5-small/1.0')
GITHUB_URL = environ.get('GITHUB_URL', 'https://github.com/GoogleCloudPlatform/kubernetes-engine-samples/tree/t5-model-serving/ai-ml/t5-model-serving')
DEFAULT_MODELS = ["t5"]
LANG_MAP = {
  "en": "English",
  "fr": "French",
  "de": "German",
  "ro": "Romanian",
}

logger.info(f"Model prediction: {PREDICTION_URL}")

def text_to_text_function(text: str = "Hello World", from_lang=LANG_MAP, to_lang=LANG_MAP) -> str:
  headers = {"Content-Type": "application/json"}
  payload = {"text": text, "from": from_lang, "to": to_lang}
  resp = requests.post(PREDICTION_URL, json=payload, headers=headers)
  if resp.status_code == 200:
    content = resp.json()
    resp = content.get("text")
  else:
    resp = "Oops, something went wrong!"

  return resp

dash = FastDash(
  callback_fn=text_to_text_function,
  title="T5 model serving",
  github_url=GITHUB_URL,
  run_kwargs=dict(debug=__name__ == "__main__", port=8050),
)

if __name__ == "__main__":
  dash.run()
