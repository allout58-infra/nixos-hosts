{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./software.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.bluetooth.enable = true;

  networking.hostName = "jhollowell-frmwk";

  services.fwupd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jhollowell = {
    isNormalUser = true;
    description = "James Hollowell";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
    initialPassword = "password1";
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
