{
  pkgs,
  config,
  ...
}: {
  services.flatpak.packages = [
    # Communication
    "us.zoom.Zoom"
    "com.discordapp.Discord"
    "com.slack.Slack"
    "im.riot.Riot" # Element

    "com.spotify.Client"

#    "com.visualstudio.code"

    "md.obsidian.Obsidian"
  ];

  users.users.jhollowell.packages = with pkgs; [
    syncthing
    syncthingtray
    nixd

    gh

    esphome

    vlc
    bitwarden-cli
    warp-terminal

    vscode.fhs # Flatpak is even more restrictive than nix pkg, so stick with nix pkg

    steam-run

    nix

    ghostty

    devenv
  ];

  fonts.packages = [pkgs.nerd-fonts.fira-code];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services = {
    tailscale = {
      enable = true;
      package = pkgs.tailscale;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [brlaser];
    };
  };

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  networking.firewall = {
    allowedUDPPorts = [
      config.services.tailscale.port
    ];
    trustedInterfaces = ["tailscale0"];
  };

  programs.nh.flake = "/home/jhollowell/nix-repos/nixos-hosts";

  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
  ];
}
