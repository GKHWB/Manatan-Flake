{
  description = "Nix flake for the Manatan immersion software";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs: 
  let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    packages = forAllSystems (system:
      let
        pkgs = import nixpkgs { inherit system; };
        manatan = pkgs.callPackage ./manatan.nix { };
      in {
        default = manatan;
      }
    );
  };
}
