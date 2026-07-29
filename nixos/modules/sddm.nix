{ pkgs, ... }:

{
  services.displayManager = {
    # Changed from "none+qtile" to just "qtile" to match modern NixOS syntax
    defaultSession = "qtile"; 

    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      
      extraPackages = with pkgs; [
        (sddm-astronaut.override {
          embeddedTheme = "astronaut";
        })
        kdePackages.qtsvg
        kdePackages.qtvirtualkeyboard
      ];
    };
  };
}
