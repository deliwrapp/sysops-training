resource "google_container_cluster" "primary" {
  # Set min_master_version explicitly, due to https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/issues/1356
  min_master_version = var.kubernetes_version != "latest" ? var.kubernetes_version : null
  addons_config {
    gke_backup_agent_config {
      enabled = true
    }
  }
}
