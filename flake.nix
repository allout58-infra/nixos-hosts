{
  description = "All my common nix hosts";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  # The release branch of the NixOS/nixpkgs repository on GitHub.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

  # region AgeNix
  inputs.agenix = {
    url = "github:ryantm/agenix";
    # optional, not necessary for the module
    inputs.nixpkgs.follows = "nixpkgs";
    # optionally choose not to download darwin deps (saves some resources on Linux)
    inputs.darwin.follows = "";
    inputs.home-manager.follows = "home-manager";
  };
  # endregion

  inputs.nixos-hardware.url = "github:NixOS/nixos-hardware";

  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-25.11";
    inputs.nixpkgs.follows = "nixpkgs-stable";
  };

  inputs.nixos-common = {
    url = "github:allout58-infra/nixos-common";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.agenix.follows = "agenix";
  };

  inputs.nixos-wsl = {
    url = "github:nix-community/NixOS-WSL/main";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.claude-code = {
    url = "github:sadjow/claude-code-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  # It is also possible to "inherit" an input from another input. This is useful to minimize
  # flake dependencies. For example, the following sets the nixpkgs input of the top-level flake
  # to be equal to the nixpkgs input of the nixops input of the top-level flake:
  # inputs.nixpkgs.url = "nixpkgs";
  # inputs.nixpkgs.follows = "nixops/nixpkgs";

  # Work-in-progress: refer to parent/sibling flakes in the same repository
  # inputs.c-hello.url = "path:../c-hello";

  outputs = all @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    agenix,
    nixos-common,
    home-manager,
    nixos-wsl,
    nixos-hardware,
    nix-flatpak,
    claude-code,
    ...
  }: let
    x86 = "x86_64-linux";
  in {
    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations = {
      jhollowell-frmwk = nixpkgs.lib.nixosSystem rec {
        system = x86;
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          nixos-common.nixosModules.latestNix
          ./jhollowell-frmwk
          nixos-hardware.nixosModules.framework-13-7040-amd
          # agenix.nixosModules.default
          #           nixos-common.nixosModules.users
          nixos-common.nixosModules.env.common
          #           nixos-common.nixosModules.net.firewall
          # nixos-common.nixosModules.net.tailscale
          nixos-common.nixosModules.workloads.diag
          nixos-common.nixosModules.workloads.plasma

          {
            nixpkgs.overlays = [claude-code.overlays.default];
            environment.systemPackages = [claude-code.packages.${system}.claude-code];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;

            home-manager.users.jhollowell = nixos-common.nixosModules.home-manager.jhollowell;
          }
        ];
      };
      nas = nixpkgs.lib.nixosSystem rec {
        system = x86;
        modules = [
          ./nas
          agenix.nixosModules.default
          nixos-common.nixosModule.users
          nixos-common.nixosModules.env.common
          nixos-common.nixosModules.net.firewall
          nixos-common.nixosModules.net.tailscale
          nixos-common.nixosModules.workloads.diag
        ];
      };
      jth-gaming-desktop-wsl = nixpkgs.lib.nixosSystem rec {
        system = x86;
        modules = [
          nixos-wsl.nixosModules.default
          ./wsl/config.nix
          agenix.nixosModules.default
          nixos-common.nixosModules.users
          nixos-common.nixosModules.env.common

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;

            home-manager.users.jhollowell = nixos-common.nixosModules.home-manager.jhollowell;
          }

          {
            networking.hostName = "jth-gaming-desktop";
            system.stateVersion = "24.05";
          }
        ];
      };
    };

    # format the nix code in this flake
    # alejandra is a nix formatter with a beautiful output
    formatter.${x86} = nixpkgs.legacyPackages.${x86}.alejandra;
  };
}
