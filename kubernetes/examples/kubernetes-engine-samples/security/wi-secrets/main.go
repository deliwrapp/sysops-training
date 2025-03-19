// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"context"
	"fmt"
	"log"
	"os"

	secretmanager "cloud.google.com/go/secretmanager/apiv1"
	secretmanagerpb "google.golang.org/genproto/googleapis/cloud/secretmanager/v1"
)

func main() {

        // Get environment variables from Pod spec.
        projectID := os.Getenv("PROJECT_ID")
        secretId := os.Getenv("SECRET_ID")
        secretVersion := os.Getenv("SECRET_VERSION")

        // Create the Secret Manager client.
        ctx := context.Background()
        client, err := secretmanager.NewClient(ctx)
        if err != nil {
                log.Fatalf("failed to setup client: %v", err)
        }
        defer client.Close()

        // Create the request to access the secret.
        accessSecretReq := &secretmanagerpb.AccessSecretVersionRequest{
                Name: fmt.Sprintf("projects/%s/secrets/%s/versions/%s", projectID, secretId, secretVersion),
        }

        secret, err := client.AccessSecretVersion(ctx, accessSecretReq)
        if err != nil {
                log.Fatalf("failed to access secret: %v", err)
        }

        // Print the secret payload.
        //
        // WARNING: Do not print the secret in a production environment - this
        // snippet is showing how to access the secret material.
        log.Printf("Welcome to the key store, here's your key:\nKey: %s", secret.Payload.Data)
}
