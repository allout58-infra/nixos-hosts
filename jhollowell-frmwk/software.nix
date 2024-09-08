{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: {
  users.users.jhollowell.packages = with pkgs-unstable; [
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
    gh
  ];

  fonts.packages = [ pkgs.fira-code-nerdfont ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services = {
    tailscale = {
      enable = true;
      package = pkgs-unstable.tailscale;
    };
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2="1";
  };

  networking.firewall = {
    allowedUDPPorts = [
      config.services.tailscale.port
    ];
    trustedInterfaces = ["tailscale0"];
  };

  programs.nh.flake = "/home/jhollowell/nix-repos/nixos-hosts";
}
