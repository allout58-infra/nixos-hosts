{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: {
  users.users.jhollowell.packages = with pkgs; [
    obsidian
    syncthing
    syncthingtray
    nixd
    # Communication
    slack
    element-desktop
    discord

    kdePackages.kdeconnect-kde
    kdePackages.kalk

    flatpak
  ];

  programs.starship.enable = true;

  services = {
    tailscale = {
      enable = true;
      package = pkgs-unstable.tailscale;
    };
  };

  networking.firewall = {
    allowedUDPPorts = [
      config.services.tailscale.port
    ];
    trustedInterfaces = ["tailscale0"];
  };
}
