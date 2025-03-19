variable "github_repository" {
  description = "The full GitHub repository name (with org/namespace)"
  default     = "dockersamples/catalog-service-node-gcn2025"
}

variable "google_cloud_location" {
  description = "The location/region to use for GCP resources"
  default     = "us-east1"
}


data "google_project" "gcn" {}

data "github_repository" "gcn" {
  full_name = var.github_repository
}

# Setup GitHub auth for the CI pipeline
resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "gcn2025-pool"
  display_name              = "GitHub CI"
}

# Create the workload identity pool provider (mapping OIDC assertions to attributes)
resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions identity pool"
  description                        = "GitHub Actions identity pool provider for automated test"

  attribute_condition = <<EOT
    assertion.repository_id == "${ data.github_repository.gcn.repo_id }" &&
    attribute.repository == "${ data.github_repository.gcn.full_name }" &&
    assertion.ref == "refs/heads/main" &&
    assertion.ref_type == "branch"
EOT

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Create a Service Account for the pipeline to use
resource "google_service_account" "github_actions" {
  account_id   = "gha-gcn-2025"
  display_name = "GHA - gcn-2025"
}

# Grant the Service Account permission to deploy to Cloud Run
resource "google_project_iam_member" "gcn" {
  project = data.google_project.gcn.id
  role     = "roles/run.admin"
  member   = "serviceAccount:${ google_service_account.github_actions.email }"
}

# Grant the Service Account permission to act as a service account user
resource "google_project_iam_member" "service_account_user" {
  project = data.google_project.gcn.id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Allow GitHub Actions to impersonate the Service Account
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${ data.github_repository.gcn.full_name }"
  ]
}

# Grant the Service Account permission to create attestations for Binary Authorization
resource "google_project_iam_member" "binary_auth_attestor" {
  project = data.google_project.gcn.id
  role    = "roles/binaryauthorization.attestorsVerifier"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Grant the Service Account permission to view notes in Container Analysis
resource "google_project_iam_member" "container_analysis_notes_viewer" {
  project = data.google_project.gcn.id
  role    = "roles/containeranalysis.notes.viewer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Grant the Service Account permission to create occurrences in Container Analysis
resource "google_project_iam_member" "container_analysis_occurrences_editor" {
  project = data.google_project.gcn.id
  role    = "roles/containeranalysis.occurrences.editor"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Grant the Service Account permission to attach occurrences to notes
resource "google_project_iam_member" "container_analysis_notes_attacher" {
  project = data.google_project.gcn.id
  role    = "roles/containeranalysis.notes.attacher"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Grant the Service Account permission to manage Artifact Registry
resource "google_project_iam_member" "artifact_registry" {
  project = data.google_project.gcn.id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

# Artifact Registry repository to push images to
resource "google_artifact_registry_repository" "gcn" {
  location      = var.google_cloud_location
  repository_id = "gcn-2025"
  description   = "Repository to hold images for the demo app"
  format        = "DOCKER"
}

# Create a Container Analysis Note (not 100% sure yet what this is for, but it's required)
resource "google_container_analysis_note" "note" {
  name = "gha-workflow-note"
  attestation_authority {
    hint {
      human_readable_name = "This note was auto-generated for attestor gha-workflow"
    }
  }
}

# Create a public/private keypair for the attestor to use
# In "real" environments, you'd typically want to use a hardware device
resource "tls_private_key" "attestor" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# Setup the Binary Authorization Attestor
resource "google_binary_authorization_attestor" "attestor" {
  name = "gha-workflow"

  attestation_authority_note {
    note_reference = google_container_analysis_note.note.name

    public_keys {
      pkix_public_key {
        signature_algorithm = "ECDSA_P256_SHA256"
        public_key_pem = tls_private_key.attestor.public_key_pem
      }
    }
  }
}

locals {
  repo_image_url = "${var.google_cloud_location}-docker.pkg.dev/${data.google_project.gcn.project_id}/${google_artifact_registry_repository.gcn.name}/application"
}




#################################################################
# Configure various GitHub Secrets for the pipeline
#################################################################

resource "github_actions_secret" "identify_provider" {
  repository      = data.github_repository.gcn.name
  secret_name     = "GCLOUD_WORKLOAD_IDENTITY_PROVIDER"
  plaintext_value = google_iam_workload_identity_pool_provider.github.name
}

resource "github_actions_secret" "service_account" {
  repository      = data.github_repository.gcn.name
  secret_name     = "GCLOUD_SERVICE_ACCOUNT"
  plaintext_value = google_service_account.github_actions.email
}

resource "github_actions_secret" "repository_url" {
  repository      = data.github_repository.gcn.name
  secret_name     = "GCLOUD_REPO_URL"
  plaintext_value = local.repo_image_url
}

resource "github_actions_secret" "dbc_builder_name" {
  repository      = data.github_repository.gcn.name
  secret_name     = "DBC_BUILDER_NAME"
  plaintext_value = "dockerdevrel/demo-builder"
}

resource "github_actions_secret" "attestor_name" {
  repository      = data.github_repository.gcn.name
  secret_name     = "GCLOUD_ATTESTOR_NAME"
  plaintext_value = google_binary_authorization_attestor.attestor.name
}

resource "github_actions_secret" "attestor_public_key_id" {
  repository      = data.github_repository.gcn.name
  secret_name     = "GCLOUD_ATTESTOR_PUBLIC_KEY_ID"
  plaintext_value = google_binary_authorization_attestor.attestor.attestation_authority_note[0].public_keys[0].id
}

resource "github_actions_secret" "attestor_key" {
  repository      = data.github_repository.gcn.name
  secret_name     = "GCLOUD_ATTESTOR_PRIVATE_KEY"
  plaintext_value = tls_private_key.attestor.private_key_pem
}
