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

    spotify

    vscode
  ];

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

  programs.nh.flake = "/home/jhollowell/nix-repos/nixos-hosts";
}
