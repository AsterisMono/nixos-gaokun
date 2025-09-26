{
  description = "NixOS for Huawei Matebook E Go";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixos-generators,
      ...
    }@inputs:
    {
      packages.aarch64-linux = {
        gaokun = nixos-generators.nixosGenerate {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nixosModules/gaokun.nix
            ./nixosModules/nix-env.nix
            ./nixosModules/access.nix
            {
              virtualisation.diskSize = 8 * 1024;
              nixpkgs.config.overlays = [
                (final: super: {
                  makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
                })
              ];
            }
          ];
          format = "raw-efi";
        };
      };
    };
}
