{ pkgs, ... }:

{
  services.displayManager = {
    defaultSession = "none+qtile"; # Boots directly into the Qtile session

    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm; # Forces SDDM to use the modern Qt6 version
      theme = "sddm-astronaut-theme"; # Activates the Astronaut theme directory
      
      # Graphic dependencies and standard Qt6 components for Astronaut theme
      extraPackages = with pkgs; [
        (sddm-astronaut.override {
          embeddedTheme = "astronaut"; # Options: "astronaut", "black_hole", "cyberpunk"
        })
        kdePackages.qtsvg             # Required for rendering theme's vector icons (.svg)
        kdePackages.qtvirtualkeyboard # Virtual keyboard integration for the login screen
      ];
    };
  };
}
