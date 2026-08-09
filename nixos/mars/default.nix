{ inputs, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # lenovo-thinkpad-l14-amd は trackpoint のホイールエミュレーション、
  # acpi_backlight=native、fstrim を含む唯一の公式 L14 AMD モジュール
  # (Gen1〜Gen4 で世代分岐なし)。ただし付属の iommu=soft は 2021年の
  # Gen1 BIOS バグ対策で、Thunderbolt 経由の DMA 攻撃保護も無効化する
  # ため明示的に外す。acpi_backlight=native は残す。
  boot.kernelParams = lib.mkForce [ "acpi_backlight=native" ];

  networking = {
    hostName = "mars";
    networkmanager.enable = true;
  };

  boot = {
    initrd = {
      systemd.enable = true;
      luks.devices."cryptroot" = {
        device = "/dev/disk/by-uuid/fee75e3c-4387-4708-a6b3-821dcaaa1955";
        allowDiscards = true;
      };
    };
    resumeDevice = "/dev/disk/by-uuid/4c49cf25-8185-489e-8d72-485d8bec4d76";
    # lanzaboote は systemd-boot モジュールを置き換える
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
        configurationLimit = 10;   # ESP 1GiB
      };
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages = [ pkgs.sbctl ];

  # TODO: us に切り替えたら変える
  console.keyMap = "jp106";

  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.th3rm1t3 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "docker" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "th3rm1t3" ];
  };

  programs.hyprland.enable = true;

  # ログイン
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      user = "greeter";
    };
  };

  virtualisation.docker.enable = true;
  services.fwupd.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  system.stateVersion = "26.05";
}