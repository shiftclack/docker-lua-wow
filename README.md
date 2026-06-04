# docker-lua-wow

This repo builds a small docker image for running tests in a World of Warcraft compatible Lua 5.1 environment.

## Features

* Small: Images are about 35MB.
* Fast: Tools are installed when the image is built, so CI jobs can run without installing dependencies first.
* Dependable: Immutable images allow for reproducible tests and builds.
* Multi-arch: Images built for both `linux/amd64` and `linux/arm64`.

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

To use it in a Github Actions workflow, you can run it in a `container` directly:

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
