{
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
    ../roles/secure-boot.nix
    ../roles/desktop.nix
  ];

  networking = {
    hostName = "mars";
    networkmanager.enable = true;
  };

  boot = {
    # lenovo-thinkpad-l14-amd は trackpoint のホイールエミュレーション、
    # acpi_backlight=native、fstrim を含む唯一の公式 L14 AMD モジュール
    # (Gen1〜Gen4 で世代分岐なし)。ただし付属の iommu=soft は 2021年の
    # Gen1 BIOS バグ対策で、Thunderbolt 経由の DMA 攻撃保護も無効化する
    # ため明示的に外す。acpi_backlight=native は残す。
    kernelParams = lib.mkForce [ "acpi_backlight=native" ];

    initrd = {
      systemd.enable = true;
      luks.devices."cryptroot" = {
        device = "/dev/disk/by-uuid/fee75e3c-4387-4708-a6b3-821dcaaa1955";
        allowDiscards = true;
        crypttabExtraOpts = [ "tpm2-device=auto" ];
      };
    };
    resumeDevice = "/dev/disk/by-uuid/4c49cf25-8185-489e-8d72-485d8bec4d76";
  };

  # TODO: us に切り替えたら変える
  console.keyMap = "jp106";

  users.users.th3rm1t3 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
  };

  system.stateVersion = "26.05";
}
