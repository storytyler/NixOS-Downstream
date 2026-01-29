{
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.chromium = {
        enable = true;

        # Extensions to install
        extensions = [
          # uBlock Origin
          { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
        ];

        # Dictionary packages
        dictionaries = with pkgs.hunspellDictsChromium; [
          en-gb
          en-us
        ];

        # Command line arguments for Chromium
        commandLineArgs = [
          # Hardware acceleration
          "--enable-gpu-rasterization"
          "--enable-oop-rasterization"
          "--enable-zero-copy"
          # Performance
          "--enable-features=VaapiVideoDecoder"
        ];

        # Native messaging hosts (e.g., KDE integration)
        nativeMessagingHosts = [ ];
      };
    })
  ];
}
