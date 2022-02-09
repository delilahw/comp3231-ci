# OS Assignment 3

[![Build](https://github.com/hellodavie/comp3231-ass3/actions/workflows/build.yml/badge.svg)](https://github.com/hellodavie/comp3231-ass3/actions/workflows/build.yml)
[![Mirror](https://github.com/hellodavie/comp3231-ass3/actions/workflows/mirror.yml/badge.svg)](https://github.com/hellodavie/comp3231-ass3/actions/workflows/mirror.yml)


This repository is automatically mirrored from [GitHub](https://github.com/hellodavie/comp3231-ass3).
Do not push to any other remotes, as conflicting changes from upstream will result in a forced push to overwrite files.

## Docker
Docker is used to facilitate building and testing OS/161 in an containerised Debian environment.
The relevant CI workflows can be found in `Dockerfile` and `scripts/`.
Use the following commands to build a docker image and start a container.
```sh
# With tags
$ docker build -t os161 . && docker run os161

# Without tags
$ docker run -it $(docker build -q .)
```

## Continuous Integration
Tests are run with the same Docker image shown above.
Linting with clang-format will be added later.
Mirroring to GitLab is also performed by the CI pipeline.


## Helper Scripts
### Runner
Use the scripts located at the root of the repository to help compile and run your code.
The `run` script will pipe your compiler output through a perl script to colourise it (boo `gcc v4.8`).
```sh
$ run --help
OS Assignment Runner by @hellodavie

Usage: run [clean | compile | install-kernel | kernel | debug | ([--]test <OS161-command>)]...

Examples:
  run
  run test
  run debug
  run compile install-kernel kernel
  run compile install --test "p /testbin/asst2"

$ run clean compile install-kernel test "p /testbin/asst2"
...
```

### Bundler
The bundle helper will automatically package and upload the bundle to CSE servers.
An ssh session will be started and you'll be dropped into a `zsh` shell to complete the assignment submission process.
