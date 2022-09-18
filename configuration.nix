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
      ExecStartPre = ''
      ${pkgs.rsync}/bin/rsync -r /iso/home/nix/ /home/nix
      '';
      ExecStart = ''
      ${pkgs.coreutils}/bin/chown -R nix /home/nix
      '';
      ExecStartPost = ''
      /run/booted-system/sw/bin/sudo -u nix ${pkgs.coreutils}/bin/chmod -R 710 /home/nix
      '';
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
      ExecStartPre = ''
      ${pkgs.nix}/bin/nix-channel --remove nixos
      '';
      ExecStart = ''
      ${pkgs.nix}/bin/nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable nixos
      '';
      ExecStop = ''
      ${pkgs.nix}/bin/nix-channel --update
      '';
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
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };


  # https://mirrors.tuna.tsinghua.edu.cn/help/nix/
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  system.autoUpgrade.channel = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-unstable/";

  environment.systemPackages = with pkgs; [
    # nyancat
    # neofetch
    # vim
    # git
    # gnupg
    # curl
    # rsync
  ];

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  programs.sway = {
    enable = false;
    # wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      waybar
      mako
      rofi
      # swaylock
      # activate-linux
      # grim
      # slurp
      # wl-clipboard
      # foot
      # emacs
      # firefox

      # netcat
      # whois
      # telnet
      # hping
      # nmap
      # tcpdump
      # nikto

    ];
  };


  isoImage.contents = [
    { source = ~/git/configs/.emacs;   target = "/home/nix/.emacs"; }
    { source = ~/.emacs.d/elpa;        target = "/home/nix/.emacs.d/elpa"; }
    { source = ~/git/configs/.vimrc;   target = "/home/nix/.vimrc"; }
    { source = ~/.vim;                 target = "/home/nix/.vim"; }
    { source = ~/git/configs/sway;     target = "/home/nix/.config/sway"; }
    { source = ~/git/configs/swaylock; target = "/home/nix/.config/swaylock"; }
    { source = ~/git/configs/waybar;   target = "/home/nix/.config/waybar"; }
    { source = ~/git/configs/rofi;     target = "/home/nix/.config/rofi"; }
    { source = ~/Pictures/wallpaper/golden-field.png;                  target = "/home/nix/Pictures/wallpaper/golden-field.png"; }
    { source = ~/git/dongdigua.github.io/org/internet_collections.org; target = "/home/nix/Documents/internet_collections.org"; }
  ];
}
