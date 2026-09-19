{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ ];
      luks.devices."cryptroot".device = "/dev/disk/by-uuid/16331fde-6c45-417c-8a8b-efaf2c195a88";
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "noatime"
        "compress=zstd:1"
      ];
    };
    "/home" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "noatime"
        "compress=zstd:1"
      ];
    };
    "/nix" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "noatime"
        "compress=zstd:1"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/8C10-7D2F";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
