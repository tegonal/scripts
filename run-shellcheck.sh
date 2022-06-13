#!/usr/bin/env bash

find . -name '*.sh' -not -path "**.history/*" -exec shellcheck -x -P "./utility" {} \;
