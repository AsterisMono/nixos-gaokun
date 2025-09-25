{
  pkgs,
  ...
}:

let
  # https://github.com/right-0903/linux-gaokun
  linux_gaokun = pkgs.buildLinux {
    version = "6.16.0";
    modDirVersion = "6.16.0-rc6";
    defconfig = "johan_defconfig";
    extraConfig = ''
      CONFIG_FB_SIMPLE y
    '';
    ignoreConfigErrors = true;
    src = pkgs.fetchurl {
      url = "https://github.com/jhovold/linux/archive/refs/heads/wip/sc8280xp-6.16-rc6.tar.gz";
      sha256 = "sha256-RA7f9jToBlEQq600jMUCvV7rMxFO4GXtjf35CdjIz0s=";
    };
    kernelPatches = [
      {
        name = "0001-sc8280xp-huawei-gaokun3-camera-dtsi";
        patch = ../patches/0001-sc8280xp-huawei-gaokun3-camera-dtsi.patch;
      }
    ];
    extraMeta.branch = "6.16";
  };
  linuxPackages_gaokun = pkgs.linuxPackagesFor linux_gaokun;
in
{
  hardware.deviceTree = {
    enable = true;
    name = "qcom/sc8280xp-huawei-gaokun3.dtb";
  };

  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = linuxPackages_gaokun;
    kernelParams = [
      "clk_ignore_unused"
      "pd_ignore_unused"
      "arm64.nopauth"
      "efi=noruntime"
    ];
  };

  networking.networkmanager.enable = true;
}
