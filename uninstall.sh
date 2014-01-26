#!/bin/sh

for name in *; do
  target="$HOME/.$name"
  if [ -e "$target" ]; then
    if [ -L "$target" ]; then
      if [ "$name" != 'install.sh' ] && [ "$name" != 'uninstall.sh' ] && [ "$name" != 'README.md' ]; then
        echo "unlinking $target"
        rm "$target"
      fi
    fi
  fi
done
