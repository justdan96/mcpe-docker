# mcpe-docker Dockerfile and Justfile

[Docker](http://docker.com) container and [Justfile](https://github.com/casey/just) to build [Minecraft on Linux](https://mcpelauncher.readthedocs.io/en/latest/getting_started.html). 

The `justfile` can be used independently to compile mcpelauncher on your own machine.

## How to Use

### 1. Clone Repository

In a command prompt:
```
git clone https://github.com/justdan96/mcpe-docker.git
```

### 2. Build Docker Container (optional)

To build the `mcpe-docker` container from source:
```
docker build -t mcpe-docker . | tee build.log
```

You can skip this step if you want to do this on your own machine instead.

### 3. Build mcpelauncher Components

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

You can also build the extractor separately with `just build-extractor`.

There are also targets for creating DEB packages, if doing this outside the Docker container make sure to install the `get-deps` script into your global PATH. Those targets names are the same as for installation just replace `install` with `deb`, i.e. `just deb-client`.
