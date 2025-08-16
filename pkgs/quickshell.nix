# designed for override from flake
{
  sources,
  callPackage,
  quickshell,
}: let
  qs-overrides = {
    gitRev = sources.quickshell.revision;
    withJemalloc = true;
    withQtSvg = true;
    withWayland = true;
    withX11 = false;
    withPipewire = true;
    withPam = true;
    withHyprland = true;
    withI3 = false;
  };
  quickshell-unwrapped = (callPackage (sources.quickshell + "/unwrapped.nix") qs-overrides).overrideAttrs {
    postPatch = ''
      # required for finger print support
      # temp measure till foxxed fixes it
      substituteInPlace src/services/greetd/connection.cpp \
          --replace-fail "	if (!this->mResponseRequired) {" "	if (false) {"
    '';
  };
  qs-patched = callPackage (sources.quickshell) {inherit quickshell-unwrapped;};
in
  if (quickshell == null)
  then qs-patched
  else quickshell
