{
  dandelion.modules.tpm = {
    lib,
    config,
    ...
  }: {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    users.users = lib.genAttrs (config.zaphkiel.data.users) (_user: {
      extraGroups = ["tss"];
    });
  };
}
