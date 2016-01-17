#!/bin/bash

set -e
set -u

# shellcheck disable=SC2002
cat backup.list | while read path; do
    backup="$HOME/backup/home/$USER/$path"
    target="$HOME/$path"
    if [ -d "$backup" ]; then
        mkdir -p "$target"
        cp -irv "$backup"/* "$target" </dev/tty
    else
        mkdir -p "$(dirname "$target")"
        cp -iv "$backup" "$target" </dev/tty
    fi
done
