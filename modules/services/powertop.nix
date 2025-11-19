{
  dandelion.modules.powertop = {lib, ...}: {
    powerManagement.powertop.enable = true;
    # multi-user.target shouldn't wait for powertop
    systemd.services.powertop.serviceConfig.Type = lib.mkForce "exec";
  };
}
