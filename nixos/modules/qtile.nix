{ config, pkgs, ... }:
{
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    services.xserver.windowManager.qtile.enable = true;

    services.xserver.windowManager.qtile = {
        enable = true;
        extraPackages = python3Packages: with python3Packages; [
            qtile-extras
        ];
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

}