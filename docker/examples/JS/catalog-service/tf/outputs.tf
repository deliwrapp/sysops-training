output "provider_name" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "service_account" {
  value = google_service_account.github_actions.email
}

output "image_repo_url" {
  value = local.repo_image_url
}

output "attestor_name" {
  value = google_binary_authorization_attestor.attestor.name
}

output "attestor_public_key_id" {
  value = google_binary_authorization_attestor.attestor.attestation_authority_note[0].public_keys[0].id
}