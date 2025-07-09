# temporary overlay till npins latest commit is merged int nixpkgs
final: prev: let
  inherit (final) fetchFromGitHub rustPlatform;
in {
  npins = prev.npins.overrideAttrs (new: old: {
    src = fetchFromGitHub {
      owner = "andir";
      repo = "npins";
      rev = "afa9fe50cb0bff9ba7e9f7796892f71722b2180d";
      sha256 = "sha256-D6dYAMk9eYpBriE07s8Q7M3WBT7uM9pz3RKIoNk+h7I=";
    };

    cargoHash = null;
    cargoDeps = rustPlatform.fetchCargoVendor {
      src = new.src;
      hash = "sha256-dBMY5L9xzq3czs5fGHFXNqzQQvHO3+c6WRY8tVvIz20=";
    };
  });
}
