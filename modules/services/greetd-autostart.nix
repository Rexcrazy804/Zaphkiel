{
  dandelion.modules.greetd-autostart = {
    services.greetd = {
      enable = true;
      settings = let
        initial_session = {
          command = "uwsm start default";
          user = "rexies";
        };
      in {
        inherit initial_session;
        default_session = initial_session;
      };
    };
  };
}
