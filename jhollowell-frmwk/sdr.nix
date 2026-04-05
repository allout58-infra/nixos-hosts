{
  pkgs,
  pkgs-stable,
  config,
  ...
}: {
  users.users.jhollowell = {
    packages = with pkgs; [
      pkgs-stable.sdrpp
      rtl-sdr
      wsjtx

      pkgs-stable.direwolf

      hamlib # rigctrl

      # dsd # removed
      pkgs-stable.mbelib

      hamrs # logger
      tqsl # ARRL Logbook of the world
      pat # winlink

      # To program the radio
      chirp

      # JACK configuration to wire audio around
      # carla
      # helvum
    ];
    extraGroups = ["plugdev" "dialout"];
  };

  # services.pipewire.extraConfig.pipewire."91-sdr-null-sinks" = {
  #   "context.objects" = [
  #     {
  #       factory = "adapter";
  #       args = {
  #         "factory.name" = "support.null-audio-sink";
  #         "node.name" = "SDR Tunnel";
  #         "node.description" = "Used to pass audio between HAM radio devices";
  #         "media.class" = "Audio/Duplex";
  #         "audio.position" = "FL,FR";
  #       };
  #     }
  #   ];
  # };

  hardware.rtl-sdr.enable = true;
}
