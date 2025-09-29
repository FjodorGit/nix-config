#!/usr/bin/env zsh
# Switch to splits layout in current tab
kitten @ goto-layout splits

window_title="nvim-$(pwd)"

kitten @ set-window-title "$window_title"
kitten @ launch --keep-focus --cwd=current --location=vsplit --bias=40 --title "opencode" opencode
kitten @ launch --keep-focus --cwd=current --location=hsplit --bias=30 --title "cli"
kitten @ send-text --match title:"$window_title" "nvim\r"
