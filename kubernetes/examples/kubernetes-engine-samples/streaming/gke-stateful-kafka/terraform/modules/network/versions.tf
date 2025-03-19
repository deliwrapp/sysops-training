terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "< 5.0" # upgrade to ~> 5.0 *AFTER* terraform-google-network module is updated (https://github.com/terraform-google-modules/terraform-google-network/pull/506)
    }
  }
  required_version = ">= 0.13"
}
