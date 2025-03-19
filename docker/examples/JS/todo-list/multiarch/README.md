## Building Multi-arch Docker Image


You can use `docker buildx` to build multi-architecture platform Docker Image 

```
 docker buildx build --platform linux/amd64 -t todo-multiarch .
```

## Inspecting the architecture of the Docker Image

```
 docker inspect --format='{{.Os}}/{{.Architecture}}' todo-multiarch:latest
```

## Result:

```
 linux/amd64
```
