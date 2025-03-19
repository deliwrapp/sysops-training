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

# Update Helm Chart.yaml dependency and version

# Usage update the Helm Chart kafka version 20.0.6

# scripts/chart.sh kafka 20.0.6 
#!/bin/bash

# Dependency name and new version as arguments
DEPENDENCY_NAME=$1
NEW_VERSION=$2

# Update the version in Chart.yaml using sed
# This sed command is designed to match the specific structure of your Chart.yaml
sed -i "/- name: $DEPENDENCY_NAME/,/version: /s/version: .*/version: $NEW_VERSION/" Chart.yaml
