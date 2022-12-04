{ config, lib, pkgs, ... }:
{
  services = {
    sshd.enable = true;
    getty.autologinUser = lib.mkDefault "nix";
    openssh.permitRootLogin = lib.mkDefault "yes";
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
    firewall.allowedTCPPorts = [ 22 80 ];
    hostName = "nixos";
  };
  time.timeZone = "Asia/Shanghai";

  users.users.root.password = "nixos";
  users.users.nix = {
    password = "nixos";
    isNormalUser = true;
    home = "/home/nix";
    extraGroups = [ "wheel" "disk" "audio" "video" "input" "systemd-journal" "networkmanager" "network" ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # https://mirrors.tuna.tsinghua.edu.cn/help/nix/
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #   }))
  # ];

  environment.systemPackages = with pkgs; [
    nyancat
    neofetch
    vim
    git
    gnupg
    curl
    aria2
    rsync
    fzf
    ranger
    testdisk
    p7zip
    doas

    emacs
    # (emacsWithPackagesFromUsePackage {
    #   config = ./.emacs;

    #   defaultInitFile = true;
    #   alwaysEnsure = true;
    # })
  ];

  # https://nixos.wiki/wiki/Linux_kernel
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelPackages = pkgs.linuxPackages_zen;

  programs.xwayland.enable = pkgs.lib.mkForce false; # well, seems it can't do this, unlike gentoo
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = false;
    extraSessionCommands = "export WLR_NO_HARDWARE_CURSORS=1";
    extraPackages = with pkgs; [
      # sway addition
      waybar
      mako
      rofi-wayland
      swaylock
      activate-linux
      grim
      slurp
      wl-clipboard
      foot

      # tools
      firefox
      vlc
      ffmpeg
      gparted

      # development
      clang
      llvm
      gdb
      gnumake
      elixir

      # net
      netcat
      inetutils
      hping
      nmap
      tcpdump

      # hack
      nikto
      metasploit
      radare2
      wifite2
    ];
  };


  isoImage.contents = [
    { source = ./.emacs;                   target = "/files/.emacs"; }
    { source = ./.vimrc;                   target = "/files/.vimrc"; }
    { source = ./sway;                     target = "/files/.config/sway"; }
    { source = ./swaylock;                 target = "/files/.config/swaylock"; }
    { source = ./waybar;                   target = "/files/.config/waybar"; }
    { source = ./rofi;                     target = "/files/.config/rofi"; }
    { source = ./centos9-motif.png;        target = "/files/Pictures/wallpaper/centos9-motif.png"; }
    { source = ./internet_collections.org; target = "/files/Documents/internet_collections.org"; }
  ];
}
