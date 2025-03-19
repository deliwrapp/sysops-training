# T5 Model Docker container

Here we provide a Dockerfile that packages t5 model into a Docker container image. This is a self-complete multi stage build process:

Build stages:

1. Download the model from huggingface (notice git-lfs during git clone)
2. Create model package (MAR file)
3. Create a final docker container to serve model

## Build

You can configure the build process by setting docker build arguments:

* `BASE_IMAGE` - base image to use for the final container (default: `pytorch/torchserve:0.7.1-cpu`)
* `MODEL_NAME` - name of the model to download from huggingface (default: `t5-small`)
* `MODEL_REPO` - repository of the model to download with git (default: `https://huggingface.co/${MODEL_NAME}`)
* `MODEL_VERSION` - version of the model to download from huggingface (default: `1.0`)

### Locally

For CPU serving:

```bash
export MACHINE="cpu"
```

For GPU serving:

```bash
export MACHINE="gpu"
```

Build docker image:

```bash
export MODEL_NAME="t5-small"
export MODEL_VERSION="1.0"
export MODEL_IMAGE="us-central1-docker.pkg.dev/$GOOGLE_CLOUD_PROJECT/models/$MODEL_NAME:$MODEL_VERSION-$MACHINE"
docker buildx build \
  --tag "$MODEL_IMAGE" \
  --build-arg BASE_IMAGE="pytorch/torchserve:0.7.1-$MACHINE" \
  --build-arg MODEL_NAME \
  --build-arg MODEL_VERSION .
gcloud auth configure-docker us-central1-docker.pkg.dev --quiet
docker push "$MODEL_IMAGE"
```

### GCP Cloud Build

Available substitutions:

* `_MACHINE` - type of base image - `cpu` or `gpu` (default: `cpu`)
* `_BASE_IMAGE` - base image to use for the final container (default: `pytorch/torchserve:0.7.1-${_MACHINE}`)
* `_MODEL_NAME` - name of the model to download from huggingface (default: `t5-small`)
* `_MODEL_REPO` - repository of the model to download with git (default: `https://huggingface.co/${_MODEL_NAME}`)
* `_MODEL_VERSION` - version of the model to download from huggingface (default: `1.0`)
* `_MODEL_IMAGE` - name of image (default: `gcr.io/${PROJECT_ID}/models/${_MODEL_NAME}:${_MODEL_VERSION}-${_MACHINE}`)

For CPU serving:

```bash
gcloud builds submit . \
  --region=us-central1 \
  --config=cloudbuild.yaml \
  --substitutions=_MACHINE=cpu
```

For GPU serving:

```bash
gcloud builds submit . \
  --region=us-central1 \
  --config=cloudbuild.yaml \
  --substitutions=_MACHINE=gpu
```

## Run

```bash
docker run --rm -it -p "8080:8080" -p "8081:8081" "$MODEL_IMAGE" torchserve --start --foreground
```
