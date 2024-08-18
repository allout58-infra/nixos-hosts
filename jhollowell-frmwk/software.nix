{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: let
  # Override discover to add flatpak backend
  discover-wrapped =
    pkgs.symlinkJoin
    {
      name = "discover-flatpak-backend";
      paths = [pkgs.kdePackages.discover];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/plasma-discover --add-flags "--backends flatpak"
      '';
    };
in {
  users.users.jhollowell.packages = with pkgs; [
    obsidian
    syncthing
    syncthingtray
    nixd
    # Communication
    slack
    element-desktop
    discord

    spotify

    kdePackages.kdeconnect-kde
    kdePackages.kalk
    kdePackages.plasma-vault
    kdePackages.kamoso
    discover-wrapped # store

    starship #to be able to explain starship promts

    jq
  ];

  programs.starship.enable = true;
  programs.command-not-found.enable = true;

  services = {
    tailscale = {
      enable = true;
      package = pkgs-unstable.tailscale;
    };
    flatpak.enable = true;
    packagekit.enable = true;
  };

  networking.firewall = {
    allowedUDPPorts = [
      config.services.tailscale.port
    ];
    trustedInterfaces = ["tailscale0"];
  };
}
