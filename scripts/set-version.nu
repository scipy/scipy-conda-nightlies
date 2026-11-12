#!/usr/bin/env -S pixi run --experimental --script
# /// conda-script
# channels = ["https://prefix.dev/conda-forge"]
# entrypoint = "nu ${SCRIPT}"
#
# [dependencies]
# nushell = "*"
# python = "*"
# /// end-conda-script

# Override the version in scipy's pyproject.toml with the git-based dev version
# (e.g. 2.0.0.dev0 -> 2.0.0.dev0+git20261112.abcdef0).
# Assumes scipy is checked out in the current directory.

let version = (^python tools/building/gitversion.py | str trim)
open --raw pyproject.toml
| str replace --regex '(?m)^version = .*$' $'version = "($version)"'
| save --force pyproject.toml

print (open --raw pyproject.toml | lines | where $it starts-with 'version = ' | str join "\n")
