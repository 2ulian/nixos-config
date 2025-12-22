#!/bin/sh

pywalfox --browser librewolf install

git clone https://github.com/2ulian/neovim-config ~/.config/nvim

rustup default stable
