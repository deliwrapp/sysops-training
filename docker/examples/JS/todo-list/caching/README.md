## Layer Caching

Now that you've seen the layering in action, there's an important lesson to learn to help decrease build times for your container images.

Once a layer changes, all downstream layers have to be recreated as well

Let's look at the Dockerfile we were using one more time...


```
FROM node:21-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
```

Going back to the image history output, we see that each command in the Dockerfile becomes a new layer in the image. You might remember that when we made a change to the image, the yarn dependencies had to be reinstalled. Is there a way to fix this? It doesn't make much sense to ship around the same dependencies every time we build, right?

To fix this, we need to restructure our Dockerfile to help support the caching of the dependencies. For Node-based applications, those dependencies are defined in the package.json file. So what if we start by copying only that file in first, install the dependencies, and then copy in everything else? Then, we only recreate the yarn dependencies if there was a change to the package.json. Make sense?

Update the Dockerfile to copy in the package.json first, install dependencies, and then copy everything else in.


```
FROM node:21-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . .
CMD ["node", "src/index.js"]
```

Create a file named .dockerignore in the same folder as the Dockerfile with the following contents.


```
node_modules
```

.dockerignore files are an easy way to selectively copy only image relevant files. You can read more about this here. In this case, the node_modules folder should be omitted in the second COPY step because otherwise it would possibly overwrite files which were created by the command in the RUN step. For further details on why this is recommended for Node.js applications as well as further best practices, have a look at their guide on Dockerizing a Node.js web app.

## Build a new image using docker build.


```
docker build -t getting-started .
```

You should see output like this...

```
[+] Building 16.1s (10/10) FINISHED
=> [internal] load build definition from Dockerfile                                               0.0s
=> => transferring dockerfile: 175B                                                               0.0s
=> [internal] load .dockerignore                                                                  0.0s
=> => transferring context: 2B                                                                    0.0s
=> [internal] load metadata for docker.io/library/node:21-alpine                                  0.0s
=> [internal] load build context                                                                  0.8s
=> => transferring context: 53.37MB                                                               0.8s
=> [1/5] FROM docker.io/library/node:21-alpine                                                    0.0s
=> CACHED [2/5] WORKDIR /app                                                                      0.0s
=> [3/5] COPY package.json yarn.lock ./                                                           0.2s
=> [4/5] RUN yarn install --production                                                           14.0s
=> [5/5] COPY . .                                                                                 0.5s 
=> exporting to image                                                                             0.6s 
=> => exporting layers                                                                            0.6s 
=> => writing image sha256:d6f819013566c54c50124ed94d5e66c452325327217f4f04399b45f94e37d25        0.0s 
=> => naming to docker.io/library/getting-started                                                 0.0s
```
You'll see that all layers were rebuilt. Perfectly fine since we changed the Dockerfile quite a bit.

Now, make a change to the src/static/index.html file (like change the <title> to say "The Awesome Todo App").

Build the Docker image now using docker build -t getting-started . again. This time, your output should look a little different.

```
[+] Building 1.2s (10/10) FINISHED
=> [internal] load build definition from Dockerfile                                               0.0s
=> => transferring dockerfile: 37B                                                                0.0s
=> [internal] load .dockerignore                                                                  0.0s
=> => transferring context: 2B                                                                    0.0s
=> [internal] load metadata for docker.io/library/node:21-alpine                                  0.0s
=> [internal] load build context                                                                  0.2s
=> => transferring context: 450.43kB                                                              0.2s
=> [1/5] FROM docker.io/library/node:21-alpine                                                    0.0s
=> CACHED [2/5] WORKDIR /app                                                                      0.0s
=> CACHED [3/5] COPY package.json yarn.lock ./                                                    0.0s
=> CACHED [4/5] RUN yarn install --production                                                     0.0s
=> [5/5] COPY . .                                                                                 0.5s
=> exporting to image                                                                             0.3s
=> => exporting layers                                                                            0.3s
=> => writing image sha256:91790c87bcb096a83c2bd4eb512bc8b134c757cda0bdee4038187f98148e2eda       0.0s
=> => naming to docker.io/library/getting-started                                                 0.0s
```

First off, you should notice that the build was MUCH faster! You'll see that several steps are using previously cached layers. So, hooray! We're using the build cache. Pushing and pulling this image and updates to it will be much faster as well. Hooray
