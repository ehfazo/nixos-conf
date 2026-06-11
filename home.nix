{ config, pkgs, ... }:

let

    na_scr = pkgs.writeShellApplication {
              name = "ns";
              runtimeInputs = with pkgs; [
                fzf
                nix-search-tv
              ];
             text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
            };

in
{
  home.username = "sorex";
  home.homeDirectory = "/home/sorex";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    na_scr
  ];


  programs.nix-search-tv.enableTelevisionIntegration = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      # Add your alias here. Note that 'sudo' is baked into the command!
      rebuild_nix = "sudo nixos-rebuild switch --flake /etc/nixos/#kaizu";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };
}
