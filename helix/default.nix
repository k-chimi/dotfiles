{ runCommand, helix }:
  runCommand "kchimi-helix" {
    src = ./config.toml;
  } ''
    mkdir $out
    cp $src $out/config.toml

    mkdir -p $out/bin
    helix_bin="${helix}/bin/hx"
    echo $'#!/usr/bin/env sh\n'"$helix_bin -c $out/config.toml "'$@' > $out/bin/hx
    chmod +x $out/bin/hx
  ''
