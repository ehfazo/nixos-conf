{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kaizu";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Dhaka";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime # For Intel 12th Gen
    ];
  };

  users.users.sorex = {
    isNormalUser = true;
    extraGroups = ["wheel" "nixos-config"];
    packages = with pkgs; [
      tree
      rofi
      thunar
      swaybg
      vis
    ];
  };

  services.displayManager.ly = {
    enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  #Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = false;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.12"
  ];

  # Neovim
  systemd.services."dynamic-provider" = {
    enable = lib.mkForce false;
    wantedBy = lib.mkForce [];
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

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    noto-fonts
  ];

  nixpkgs.overlays = [
    inputs.helium.overlays.default
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "cloudflare-warp"
      "zoom"
      "spotify"
      "davinci-resolve"
      "ventoy"
      "intelephense"
    ];

  programs.firefox.enable = true;
  environment.systemPackages =
    [
      inputs.rux.packages.${pkgs.stdenv.hostPlatform.system}.default
    ]
    ++ (with pkgs; [
      bash
      vim
      wget
      foot
      waybar
      kitty
      wl-clipboard
      openbangla-keyboard
      inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      helium
      neovim
      cloudflare-warp
      bluez
      bluez-tools
      gnutar
      btop
      ventoy
      go
      zoom-us
      nerd-fonts.iosevka
      lua51Packages.tree-sitter-cli
      # Neovim
      c3-lsp
      clang-tools
      vscode-css-languageserver
      gopls
      haskell-language-server
      vscode-json-languageserver
      lua-language-server
      nil
      intelephense
      rust-analyzer
      serve-d
      templ
      typescript-language-server
      zls
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
      fuzzel
      wine
      wiremix
      nautilus
      greetd
      tuigreet
      sway
    ]);

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "26.05";
}
