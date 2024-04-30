#!/bin/sh

# Install Oh my zsh
if [[ ! $ZSH ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

for name in *; do
  ignored=("install.sh" "uninstall.sh" "README.md")
  if [[ ! $ignored =~ $name ]] && [[ ! -d $name ]]; then
    target="$HOME/.$name"
    if [ -e "$target" ]; then
      if [ ! -L "$target" ]; then
        echo "WARNING: $target exists but is not a symlink."
      else
        echo "Already Linked $target"
      fi
    else
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

cd config

for name in *; do
  target="$HOME/.config/$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      echo "WARNING: $target exists but is not a symlink."
    else
      echo "Already Linked $target"
    fi
  else
    echo "Creating $target"
    ln -s "$PWD/$name" "$target"
  fi
done

cd ..
