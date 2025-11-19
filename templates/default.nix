{
  rust-minimal = {
    path = ./Rust/minimal;
    description = "Rust flake with oxalica overlay + mold linker";
    welcomeText = ''
      # A minimal rust template by Rexiel Scarlet (Rexcrazy804)
    '';
  };

  rust-npins = {
    path = ./Rust/npins-minimal;
    description = "Rust npins template with oxalica overlay + mold linker";
    welcomeText = ''
      # A minimal rust template
      - oxalica rust overlay
      - npins based tempalte

      ## WARNING
      - you must run `npins init` after pulling this template to generate `npins/default.nix`
      - the sources are locked with `npins/sources.json` and can be updated via `npins update`

      > In the event that these steps fail, please open an issue on Rexcrazy804/Zaphkiel
    '';
  };

  nix-minimal = {
    path = ./Nix/flake;
    description = "A minimal nix flake template with the lambda for ease of use";
    welcomeText = ''
      # A minimal nix flake template by Rexiel Scarlet (Rexcrazy804)
    '';
  };

  vm-basic = {
    path = ./Nix/basic-vm;
    description = "Basic npins based virtual machine template";
    welcomeText = ''
      # Npins based nixos container template
      - simple vm template orchestrated by npins
      - depends solely on nixpkgs

      ## instructions
      - `default.nix` is your configuration.nix to build upon
      - utilize the `build.sh` script to build the vm
      - the built vm can be run via `./result/bin/run-basicvm-vm`
      - initial username is `rexies` and password is `kokomi`
      - to exit the vm run `sudo poweroff`

      ##  WARNING
      - `npins/` is not provided, please generate it with `npins init`
      - `chmod u+x build.sh` if it is not executable

      > template provided by Rexcrazy804/Zaphkiel
    '';
  };
}
