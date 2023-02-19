{
  description = "StashApp organizer";
  
  inputs  = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix.url = "github:nix-community/gomod2nix";
    stashapp = {
      type = "github";
      owner = "stashapp";
      repo = "stash";
      ref = "v0.19.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, gomod2nix, stashapp }:
    (flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ gomod2nix.overlays.default ];
          };

        in
        {
          packages.default = pkgs.callPackage ./. { inherit stashapp; };
          devShells.default = import ./shell.nix { inherit pkgs; inherit stashapp; };
        })
    );
}
