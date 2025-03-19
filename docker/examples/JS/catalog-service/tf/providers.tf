terraform {
  backend "gcs" {
    bucket  = "gcn-2025-tf"
    prefix  = "terraform/state"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.25.0"
    }
    
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.6"
    }
  }
}

provider "google" {
  project = "gcn-2025"
  region  = "us-east1"
}

provider "github" {
  owner = "dockersamples"
}

provider "tls" { }