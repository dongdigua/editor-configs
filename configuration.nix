{ config, lib, pkgs, ... }:
{
  services = {
    sshd.enable = true;
    getty.autologinUser = lib.mkDefault "nix";
    openssh.settings.PermitRootLogin = lib.mkDefault "yes";
  };

  systemd.services.sync-home = {
    enable = true;
    wantedBy = [ "default.target" ];
    description = "Copy home contents from iso";
    serviceConfig = {
      Type = "forking";
      ExecStartPre = "${pkgs.rsync}/bin/rsync -r /iso/files/ /home/nix";
      ExecStart = "${pkgs.coreutils}/bin/chown -R nix /home/nix";
      ExecStartPost = "/run/booted-system/sw/bin/sudo -u nix ${pkgs.coreutils}/bin/chmod -R 710 /home/nix";
      ExecStop = "";
    };
  };

  systemd.services.update-channel = {
    enable = true;
    wantedBy = [ "default.target" ];
    after = [ "network.target" "network-online.target" ];
    description = "Update channel";
    serviceConfig = {
      Type = "forking";
      ExecStartPre = "${pkgs.nix}/bin/nix-channel --remove nixos";
      ExecStart = "${pkgs.nix}/bin/nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable nixos";
      ExecStop = "${pkgs.nix}/bin/nix-channel --update";
    };
  };

  networking = {
    firewall.allowedTCPPorts = [ 22 80 1965 2333 ];
    hostName = "nixos";
    extraHosts =
      ''
        140.82.114.4 github.com
      ''; # fuck DNS pollution
  };
  time.timeZone = "Asia/Shanghai";

  users.users.root.password = "nixos";
  users.users.nix = {
    password = "nixos";
    isNormalUser = true;
    home = "/home/nix";
    extraGroups = [ "wheel" "disk" "audio" "video" "input" "systemd-journal" "networkmanager" "network" "gnunet" ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.doas = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # https://mirrors.tuna.tsinghua.edu.cn/help/nix/
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    myRepo = import (builtins.fetchTarball "https://github.com/dongdigua/nur-pkg/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  environment.systemPackages = with pkgs; [
    # basic
    neovim
    elvis # fantastic
    git
    netcat
    curl
    doas
    psmisc

    # util
    neofetch
    gnupg
    age
    signify
    aria2
    rsync
    fzf
    ranger
    testdisk
    p7zip
    pigz
    htop
    ripgrep
    w3m

    # fun
    nyancat
    nethack
    av-98
    libsixel
    weechat

    # not quite official
    emacsPgtk
    myRepo.bsdtetris
  ];

  # https://nixos.wiki/wiki/Linux_kernel
#ifndef hack
  boot.kernelPackages = pkgs.linuxPackages_lqx;
#endif

  programs.xwayland.enable = pkgs.lib.mkForce false; # well, seems it can't do this, unlike gentoo
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = false;
    extraSessionCommands = "export WLR_NO_HARDWARE_CURSORS=1 MOZ_ENABLE_WAYLAND=1 TOR_SKIP_LAUNCH=1 TOR_TRANSPROXY=1";
    extraPackages = with pkgs; [
      # sway addition
      waybar
      mako
      rofi-wayland
      activate-linux
      grim
      slurp
      wl-clipboard
      foot
      light

      # tools
      (tor-browser-bundle-bin.override {
        useHardenedMalloc = false; # https://github.com/NixOS/nixpkgs/issues/146401
        # as a replacement of firefox, add 200MiB of tor
        # TOR_SKIP_LAUNCH=1 TOR_TRANSPROXY=1 (I set this by default bcause of GFW)
        # network.proxy.type -> 0
        # network.dns.disabled -> false
      })
      neovide
      pcmanfm
      ffmpeg-full
      gparted
      #pandoc ghc is too large
      feh
      frp

      # development
      myRepo.cproc # just try sonething new, probably change back
      qbe
      gdb
      gnumake
      lua
      elixir # 600MiB, but I must have this
      rustup # rust itself is 2GiB
      racket-minimal # 400MiB, enough for slideshow? full is 900MiB
      binutils
      picocom # better than minicom

      # net
      inetutils
      hping
      nmap
      tcpdump
      gnunet

#ifdef hack
      nikto
      metasploit
      radare2
      aircrack-ng
      macchanger
      freerdp
      python310Packages.scapy
#endif
    ];
  };


  isoImage.contents = [
    { source = ./.emacs;                   target = "/files/.emacs"; }
    { source = ./init.vim;                 target = "/files/.config/nvim/init.vim"; }
    { source = ./.nethackrc;               target = "/files/.nethackrc"; }
    { source = ./sway;                     target = "/files/.config/sway"; }
    { source = ./waybar;                   target = "/files/.config/waybar"; }
    { source = ./rofi;                     target = "/files/.config/rofi"; }
    # by downloading
    { source = ./centos9-motif.png;        target = "/files/Pictures/wallpaper/centos9-motif.png"; }
    { source = ./internet_collections.org; target = "/files/Documents/internet_collections.org"; }
    # fallbacks
    { source = ./fallbacks/min-pkg.el;     target = "/files/min-pkg.el"; }
    { source = ./fallbacks/foot.ini;       target = "/files/.config/foot/foot.ini"; }
  ];
}
