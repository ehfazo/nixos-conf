{ config, pkgs, ... }:

let
  dmscripts = pkgs.stdenv.mkDerivation {
    pname = "dmscripts";
    version = "git";

    src = pkgs.fetchFromGitLab {
      owner = "dwt1";
      repo = "dmscripts";
      rev = "master";
      sha256 = "sha256-EF5QI/dydeT5xecgO+vsksvPU76tepNiYGxA6loTS+w="; 
    };

    nativeBuildInputs = [ pkgs.pandoc ];

    installPhase = ''
      mkdir -p $out/bin
      cp -r scripts/* $out/bin/
      chmod +x $out/bin/*
    '';

};
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
    dmscripts
    dmenu    
    xdotool
    xclip
    na_scr
  ];

  xdg.configFile."dmscripts/config".text = ''
    DMTERM="foot"
    DMBROWSER="firefox"
  '';

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
