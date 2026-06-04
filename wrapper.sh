#!/bin/sh
# can't find main.lua unless the cwd is the installation path?
cd /usr/local/lua-language-server
exec /usr/local/lua-language-server/bin/lua-language-server "$@"
