
{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Neovim
  systemd.services."dynamic-provider" = {
    enable = lib.mkForce false;
    wantedBy = lib.mkForce [ ];
    unitConfig.Masked = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true; 

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };


  # Cloudflare
  services.cloudflare-warp.enable = true;
  # services.getty.autologinUser = "sorex";

  networking.hostName = "kaizu"; 

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Dhaka";
 
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # git-ai
  users.groups.nixos-config = {};
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "sorex";
        email = "ehfazinfo@gmail.com";
      };
      safe = {
        directory = "/etc/nixos";
      };
      ai = {
        agent = "gemini";
        model = "gemini-2.5-flash";
      };
    };
  };

  users.users.sorex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nixos-config" ];
    packages = with pkgs; [
      tree
    ];
  };


  # Da Vinci Resolv
   hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
        intel-compute-runtime # For Intel 12th Gen and newer
    ];
  };


  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    noto-fonts
  ];

  nixpkgs.overlays = [
    inputs.helium.overlays.default
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
   "cloudflare-warp"
   "zoom"
   "spotify"
   "davinci-resolve"
  ];

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    bash
    vim
    wget
    foot
    waybar
    kitty
    inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.sherlock.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
    helium
    neovim
    cloudflare-warp
    bluez
    bluez-tools
    gnutar
    btop
    go
    bluetuith
    zoom-us
    nerd-fonts.iosevka
    lua51Packages.tree-sitter-cli
    # Neovim
    clang
    luaPackages.luarocks
    lua5_1
    lua51Packages.jsregexp
    ripgrep
    fd
    lazygit
    fzf
    luaPackages.luasnip
    zip
    unzip
    cargo
    ruby
    regex-cli
    trash-cli
    sqlite
    mermaid-cli
    spotify
    ffmpeg
    davinci-resolve
    noto-fonts
    nix-search-tv
    # git-ai
    gemini-cli
    jq
    gum
    git
    # Hyprland
    hyprpaper
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  system.stateVersion = "26.05"; 

}

