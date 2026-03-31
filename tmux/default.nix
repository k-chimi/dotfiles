{ runCommand, tmux }:
  runCommand "kchimi-tmux" {
    src = ./tmux.conf;
  } ''
    mkdir $out
    cp $src $out/tmux.conf

    mkdir -p $out/bin
    tmux_bin="${tmux}/bin/tmux"
    echo $'#!/usr/bin/env bash\n'"$tmux_bin -f $out/tmux.conf"' $@' > $out/bin/tmux
    chmod +x $out/bin/tmux
  ''
