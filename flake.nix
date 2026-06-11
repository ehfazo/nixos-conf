{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/v0.55.0";

    nixcache.url = "github:ehfazo/nixcache-oci";

    rux.url = "github:rux-lang/Rux/dev";

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayugram-desktop = {
      type = "git";
      submodules = true;
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tuigreet-fork.url = "github:NotAShelf/tuigreet";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    nixcache,
    rux,
    ayugram-desktop,
    tuigreet-fork,
    ...
  }: {
    nixosConfigurations.kaizu = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix

        home-manager.nixosModules.home-manager
        nixcache.nixosModules.default

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.sorex = import ./home.nix;
            backupFileExtension = "backup";
          };

          services.nixcache-proxy = {
            enable = true;
            publicKey = "my-cache-1:3S5BDRpoA7ObRQg9pPoNoAxTqqn5zjPcXjlUrhY1nVo=";
          };
        }
      ];
    };
  };
}
