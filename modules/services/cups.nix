# the difference between this and printing is that this is for the printer HOST
# wherease printing is for the CLIENT
{
  dandelion.modules.cups = {
    pkgs,
    lib,
    config,
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

    hardware.sane.enable = true;
    users.users = lib.genAttrs config.zaphkiel.data.users (_user: {
      extraGroups = ["scanner" "lp"];
    });
  };
}
