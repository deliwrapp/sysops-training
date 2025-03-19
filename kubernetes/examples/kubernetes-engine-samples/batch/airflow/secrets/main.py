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

# [START gke_batch_airflow_secrets_generator]
from cryptography.fernet import Fernet
import secrets;

fernet_key = Fernet.generate_key()
print(f'Fernet Key: {fernet_key.decode()}')
print(f'Webserver Secret Key: {secrets.token_hex(16)}')
# [END gke_batch_airflow_secrets_generator]
