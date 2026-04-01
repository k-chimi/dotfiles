{
  description = "K Chimi's basic enviroment";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ { 
    nixpkgs, flake-parts, systems, ...
  }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;
    perSystem = { pkgs, ... }: rec {
      packages.kchimi-helix =
        pkgs.callPackage ./helix/default.nix { };

      packages.kchimi-tmux =
        pkgs.callPackage ./tmux/default.nix { };

      packages.kchimi-basic-full =
        pkgs.buildEnv {
          name = "kchimi-basic-full";
          paths = (with pkgs; [
            git
            jq
            yq
            curl
            wget
            gnugrep
            man
            gnumake
            htop
            less
            bash-completion
          ]) ++ (with packages; [
            kchimi-tmux
            kchimi-helix
          ]);
        };

      packages.default = packages.kchimi-basic-full;

      devShells.kchimi-shell-ps1 =
        pkgs.callPackage ./shell-ps1/default.nix { };
        
      devShells.kchimi-shell-profile =
        pkgs.callPackage ./shell-profile/default.nix { };
        
      devShells.kchimi-shell-profiler =
        pkgs.callPackage ./shell-profiler/default.nix { }; 

      devShells.default =
        let defaultPackage = packages.default;
        in pkgs.mkShell {
          name = "kchimi-dev";

          packages = [ defaultPackage ];
          inputsFrom = with devShells; [
            devShells.kchimi-shell-profiler
            devShells.kchimi-shell-profile
            devShells.kchimi-shell-ps1
          ];

          shellHook = ''
            . ${defaultPackage}/share/bash-completion/bash_completion
          '';
        };
    };
  };
}
