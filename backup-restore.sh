#!/bin/bash

set -e
set -u

cd `dirname "$0"`

for path in `cat backup.list`; do
    backup="$HOME/backup/home/nobuto/$path"
    target="$HOME/$path"
    if [ -d "$backup" ]; then
        mkdir -p "$target"
        cp -irv "$backup"/* "$target"
    else
        mkdir -p "$(dirname "$target")"
        cp -iv "$backup" "$target"
    fi
done
