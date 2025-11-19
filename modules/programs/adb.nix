{
  dandelion.modules.adb = {
    programs.adb.enable = true;
    users.users.rexies.extraGroups = ["adbusers" "kvm"];
  };
}
