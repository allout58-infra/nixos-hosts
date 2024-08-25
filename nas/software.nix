{
  pkgs,
  pkgs-unstable,
  config,
  ...
}: {
  programs.starship.enable = true;

  boot.zfs.enable = true;

  # services.sanoid
  # services.syncoid
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
  };
}
