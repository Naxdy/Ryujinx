{
  description = "Experimental Nintendo Switch Emulator written in C#";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }: (flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system: {
      packages.default =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
            ];
          };
        in
        pkgs.ryujinx;
    })) // {
      nixosModules.default = { config, lib, pkgs, ... }: {
        nixpkgs.overlays = [
          self.overlays.default
        ];
      };

      overlays.default = final: prev: {
        ryujinx = final.callPackage ./package.nix {
          src = self;
        };
      };
    };
}
