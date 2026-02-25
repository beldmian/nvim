{
  description = "Portable nixvim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, ... }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = lib.genAttrs systems;

      mkPkgs = system:
        import nixpkgs {
          inherit system;
        };

      mkNixvim = system:
        let
          pkgs = mkPkgs system;
        in
        nixvim.legacyPackages.${system}.makeNixvimWithModule {
          inherit pkgs;
          module = import ./nixvim;
        };

      mkApp = drv: {
        type = "app";
        program = "${drv}/bin/nvim";
        meta.description = "Portable nixvim from this flake";
      };
    in
    {
      packages = forAllSystems (
        system:
        let
          drv = mkNixvim system;
        in
        {
          default = drv;
          nixvim = drv;
        }
      );

      apps = forAllSystems (
        system:
        let
          drv = self.packages.${system}.default;
        in
        {
          default = mkApp drv;
          nvim = mkApp drv;
        }
      );

      lib.nixvimModule = import ./nixvim;

      checks = forAllSystems (system: {
        default = self.packages.${system}.default;
      });
    };
}
