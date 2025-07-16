#!/bin/sh

for name in *; do
  ignored=("install.sh" "uninstall.sh" "README.md")
  if [[ ! $ignored =~ $name ]] && [[ ! -d $name ]]; then
    target="$HOME/.$name"
    if [ -L "$target" ]; then
      echo "Unlinking $target"
      rm "$target"
    fi
  fi
done

cd config

for name in *; do
  target="$HOME/.config/$name"
  if [ -L "$target" ]; then
    echo "Unlinking $target"
    rm "$target"
  fi
done

cd ..
