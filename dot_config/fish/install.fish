#!/usr/bin/env fish
curl -L https://get.oh-my.fish | fish
omf install https://github.com/catppuccin/fish
omf install bashh
omf install bass
fish_config theme save "Catppuccin Mocha"
