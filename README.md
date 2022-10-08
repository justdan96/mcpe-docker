# mcpe-docker Dockerfile and Justfile

[Docker](http://docker.com) container to build [Minecraft on Linux](https://mcpelauncher.readthedocs.io/en/latest/getting_started.html). 

The `justfile` can be used independently to compile mcpelauncher on your own machine.


## Usage

### Build Docker Container

Or build `mcpe-docker` from source:
```
docker build -t mcpe-docker . | tee build.log
```

### Build mcpelauncher Components

There is a `justfile` included to help build components from source. To run this in the Docker container and print a list of targets run the below:

```
docker run -it --rm -v $(pwd):/workdir -w="/workdir" mcpe-docker just
```

Otherwise just run `just` directly on your own machine.

The typical targets you would want to run (in order) are:
1. `just build-client`
2. `sudo just install-client`
3. `just build-ui`
4. `sudo just install-ui`
