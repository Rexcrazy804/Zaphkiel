{ ... }: {
  imports = [
    ../../nixosModules/external/matugen
  ];
  programs.matugen = {
    enable = true;
    wallpaper = ./kokomi_116824847_p0_cropped.jpg;
  };
}
