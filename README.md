# docker-lua-wow

The repo builds a small docker image for running tests in a World of Warcraft compatible Lua 5.1 environment.

## Features

* Small: Images are about 35MB.
* Fast: All software is installed at build time. No time is wasted installing at container runtime.
* Dependable: Immutable images allow for reproducible tests and builds.
* Multi-arch: Images built for both the `amd64` and `arm64` platforms.

## What's included

* [Lua 5.1](https://www.lua.org/)
* [busted](https://github.com/lunarmodules/busted)
* [lua-check](https://github.com/mpeterv/luacheck)
* [luacov](https://lunarmodules.github.io/luacov/)
* [luasrcdiet](https://github.com/jirutka/luasrcdiet)
* [lua-language-server](https://github.com/LuaLS/lua-language-server)
* `make`

## Usage

To pull the image:

```shell
$ docker pull ghcr.io/shiftclack/lua-wow:latest
```

To use it in a Github Actions workflow, you can run it in a `container` directly. This way no 
additional software needs to be installed at runtime:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container: ghcr.io/shiftclack/lua-wow:latest
    steps:
      - name: checkout
        uses: actions/checkout@v6

      - name: Run unit tests
        run: |
          make check
```

_It is recommended for production use to pin to a specific Docker image tag instead of using `latest`._

## Development

To build the image from the `Dockerfile`:
```shell
$ make build
```
