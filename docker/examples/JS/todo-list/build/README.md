## Building the todo-list app

```
 docker build -t todo-list-app .
```

## Listing the images


```
 docker images
REPOSITORY                            TAG               IMAGE ID       CREATED          SIZE
ajeetraina/tod                        latest            895dd0758057   7 seconds ago    1.77GB
```


## Running the container

```
 docker run -d -p 3000:3000 todo-list-app
```

## Accessing the app

Open https://localhost:3000 to access the todo-list app.

<img width="668" alt="image" src="https://github.com/ajeetraina/todo-list/assets/313480/9c63f847-3ca6-491a-aca2-1bcb593e63cb">



