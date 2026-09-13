{
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.self.legacyPackages.${system}) sources;

  username = "rexies";
  dots = config.hjem.users.${username}.impure.dotsDir;
in {
  hjem.users.${username}.xdg.config.files = {
    # terminal
    "git/config".source = dots + "/git/config";
    "jj/config.toml".source = dots + "/jj/config.toml";
    "fish/themes".source = sources.rosep-fish + "/themes";
    "fish/config.fish".source = dots + "/fish/config.fish";
    # NOTE: required bat cache --build before theme can be used
    "bat/config".source = dots + "/bat/config";
    "bat/themes".source = sources.catp-bat + "/themes";
    "shpool/config.toml".source = dots + "/shpool/config.toml";
    "yazi/yazi.toml".source = dots + "/yazi/yazi.toml";
    "yazi/keymap.toml".source = dots + "/yazi/keymap.toml";
    "booru/config.toml".source = dots + "/booru/config.toml";
  };
}
