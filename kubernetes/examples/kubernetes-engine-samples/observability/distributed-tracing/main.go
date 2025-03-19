/*
Copyright 2019 Google LLC
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
https://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

// [START gke_cloudtrace_imports]
import (
	"context"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strconv"

	cloudtrace "github.com/GoogleCloudPlatform/opentelemetry-operations-go/exporter/trace"
	"github.com/gorilla/mux"
	"go.opentelemetry.io/contrib/detectors/gcp"
	"go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp"
	"go.opentelemetry.io/contrib/propagators/autoprop"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/sdk/resource"
	"go.opentelemetry.io/otel/sdk/trace"
)

// [END gke_cloudtrace_imports]

// [START gke_cloudtrace_mainhandler]
func mainHandler(w http.ResponseWriter, r *http.Request) {
	// Use otelhttp to record a span for the outgoing call, and propagate
	// context to the destination.
	destination := os.Getenv("DESTINATION_URL")
	resp, err := otelhttp.Get(r.Context(), destination)
	if err != nil {
		log.Fatal("could not fetch remote endpoint")
	}
	defer resp.Body.Close()
	_, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("could not read response from %v", destination)
	}

	fmt.Fprint(w, strconv.Itoa(resp.StatusCode))
}

// [END gke_cloudtrace_mainhandler]
// [START gke_cloudtrace_main]
func main() {
	ctx := context.Background()
	// Set up the Cloud Trace exporter.
	exporter, err := cloudtrace.New()
	if err != nil {
		log.Fatalf("cloudtrace.New: %v", err)
	}
	// Identify your application using resource detection.
	res, err := resource.New(ctx,
		// Use the GCP resource detector to detect information about the GKE Cluster.
		resource.WithDetectors(gcp.NewDetector()),
		resource.WithTelemetrySDK(),
	)
	if err != nil {
		log.Fatalf("resource.New: %v", err)
	}
	tp := trace.NewTracerProvider(
		trace.WithBatcher(exporter),
		trace.WithResource(res),
	)
	// Set the global TracerProvider which is used by otelhttp to record spans.
	otel.SetTracerProvider(tp)
	// Flush any pending spans on shutdown.
	defer tp.ForceFlush(ctx)

	// Set the global Propagators which is used by otelhttp to propagate
	// context using the w3c traceparent and baggage formats.
	otel.SetTextMapPropagator(autoprop.NewTextMapPropagator())

	// Handle incoming request.
	r := mux.NewRouter()
	r.HandleFunc("/", mainHandler)
	var handler http.Handler = r

	// Use otelhttp to create spans and extract context for incoming http
	// requests.
	handler = otelhttp.NewHandler(handler, "server")
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%v", os.Getenv("PORT")), handler))
}

// [END gke_cloudtrace_main]
