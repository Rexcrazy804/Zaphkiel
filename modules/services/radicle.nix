{
  dandelion.modules.radicle = {
    services.radicle = {
      enable = true;
      node = {
        listenAddress = "0.0.0.0";
        listenPort = 8775;
      };
      settings = {
        preferredSeeds = [
          "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@iris.radicle.network:8776"
          "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@rosa.radicle.network:8776"
        ];
        node = {
          seedingPolicy.default = "block";
        };
      };
    };
  };
}
