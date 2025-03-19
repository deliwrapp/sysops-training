# Terraform & Cloud Build triggers

This directory contains Terraform scripts necessary to deploy [Cloud Build](https://cloud.google.com/build/) triggers which automatically build new sample images on changes.

**Note**: This directory is for the repo maintainers and are not relevant to end-users.

## Cloud Build triggers

You can access Cloud Build triggers [in the Console](https://console.cloud.google.com/cloud-build/triggers?project=google-samples).

Triggers automatically run when changes get merged in the `main` branch, but you can also manually run triggers by clicking the **Run** button.

Runs and associated logs can be found in the [Build history](https://console.cloud.google.com/cloud-build/builds?project=google-samples) page.

## Reapply Terraform scripts

Once changes to the Terraform scripts has been merged, we need to apply these changes in the Google Cloud project.

1. Clone this repo.

   ```sh
   git clone https://github.com/GoogleCloudPlatform/kubernetes-engine-samples
   cd kubernetes-engine-samples/.github/terraform/
   ```

2. Change context to point to the `google-samples` project.

   ```sh
   gcloud config set project google-samples
   ```

3. Apply the Terraform changes.

   ```sh
   terraform init
   terraform apply
   ```

   Type in _yes_ when prompted.

   The first time a new Cloud Build trigger is added, it will not automatically run (but you may decide to manually run it). Further changes will run the trigger automatically.
