pkgs @ { runCommand, writeTextFile, formats, helix }: {
  MkHelixRuntime =
    { name ? "helix-runtime", runtimes ? [] }:
      let
        extendRuntime = drv:
          if builtins.readFileType drv == "directory" then
            ''
              cp -r ${drv}/* $out/helix/runtime
            ''
          else
            ''
              { . ${drv}; }
            ''
          ;
        commandList = [
          "mkdir -p $out/helix/runtime"
        ] ++ (builtins.map (extendRuntime) runtimes);
        commands = builtins.concatStringsSep "\n" commandList;
      in
        runCommand name {} commands
      ;

  MkCustomizedHelix =
    { name ? "customized-helix", helix ? pkgs.helix, runtime ? helix.runtime }:
      runCommand name {} ''
        mkdir -p $out/bin
        helix_bin="${helix}/bin/hx"
        echo $'#!/usr/bin/env sh\nXDG_CONFIG_HOME="${runtime}" '"$helix_bin "'$@' > $out/bin/hx
        chmod +x $out/bin/hx
      ''
    ;

  MkConfig =
    { name ? "helix-config", config ? {}, derivationArgs ? {} }:
      let
        toml = formats.toml {};
      in
        writeTextFile {
          inherit name derivationArgs;
          text = ''
            cat ${toml.generate name config} >> $out/helix/config.toml
          '';
        }
      ;

  MkLanguage =
    attrs @ { name, derivationArgs ? {}, ... }:
      let
        toml = formats.toml {};
        config = builtins.removeAttrs attrs [
          "derivationArgs"
        ];
      in
        writeTextFile {
          inherit name derivationArgs;
          text = ''
            echo '[[language]]'              >> $out/helix/languages.toml
            cat ${toml.generate name config} >> $out/helix/languages.toml
          '';
        }
      ;

  MkLanguageServer =
    attrs @ { name, derivationArgs ? {}, ... }:
      let
        toml = formats.toml {};
        config = builtins.removeAttrs attrs [
          "derivationArgs"
        ];
      in
        writeTextFile {
          inherit name derivationArgs;
          text = ''
            echo '[language-server.${name}]' >> $out/helix/languages.toml
            cat ${toml.generate name config} >> $out/helix/languages.toml
          '';
        }
      ;
}
