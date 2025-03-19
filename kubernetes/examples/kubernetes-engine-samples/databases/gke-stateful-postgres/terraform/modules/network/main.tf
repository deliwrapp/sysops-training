#Copyright 2022 Google LLC

#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at

#    http://www.apache.org/licenses/LICENSE-2.0

#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

// [START vpc_multi_region_network]
module "gcp-network" {
  source  = "terraform-google-modules/network/google"
  version = "< 8.0.0"

  project_id   = var.project_id
  network_name = "vpc-gke-postgresql"

  subnets = [
    {
      subnet_name           = "snet-gke-postgresql-us-central1"
      subnet_ip             = "10.0.0.0/17"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
    {
      subnet_name           = "snet-gke-postgresql-us-west1"
      subnet_ip             = "10.0.128.0/17"
      subnet_region         = "us-west1"
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    ("snet-gke-postgresql-us-central1") = [
      {
        range_name    = "ip-range-pods-db1"
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = "ip-range-svc-db1"
        ip_cidr_range = "192.168.64.0/18"
      },
    ],
    ("snet-gke-postgresql-us-west1") = [
      {
        range_name    = "ip-range-pods-db2"
        ip_cidr_range = "192.168.128.0/18"
      },
      {
        range_name    = "ip-range-svc-db2"
        ip_cidr_range = "192.168.192.0/18"
      },
    ]
  }
}

output "network_name" {
  value = module.gcp-network.network_name
}

output "primary_subnet_name" {
  value = module.gcp-network.subnets_names[0]
}

output "secondary_subnet_name" {
  value = module.gcp-network.subnets_names[1]
}
// [END vpc_multi_region_network]