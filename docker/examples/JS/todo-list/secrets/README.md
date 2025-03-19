# Using Secrets with Docker Compose

If you're using Docker Compose without Swarm mode enabled, you won't be able to create secrets using the docker secret command because it's specific to Swarm mode.

Docker Compose itself supports defining secrets directly in the docker-compose.yml file using the secrets key, without requiring Swarm mode. When you define secrets in this way, Docker Compose manages the secrets locally, making them available to the services in your Compose environment.

# Creating a secrets file

```
 echo "ABCdefGHIJ" > secret.txtvi
```

## Running the Compose 

```
 docker compose up 
```


