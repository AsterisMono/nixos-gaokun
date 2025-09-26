{
  description = "NixOS for Huawei Matebook E Go";

  nixConfig = {
    extra-substituters = [ "https://nvirellia.cachix.org" ];
    extra-trusted-public-keys = [
      "nvirellia.cachix.org-1:pl3qPnZsyhpOxIaxPYE1qSHRsfj9g56euaMjw5rtfxY="
    ];
  };

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
            }
          ];
          format = "raw-efi";
        };
      };
    };
}
