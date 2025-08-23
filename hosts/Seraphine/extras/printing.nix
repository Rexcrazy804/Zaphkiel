{
  pkgs,
  lib,
  ...
}: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
  services.printing = {
    enable = true;
    allowFrom = ["all"];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    drivers = lib.attrValues {
      inherit (pkgs) cnijfilter_4_00 canon-cups-ufr2;
    };
  };
}
