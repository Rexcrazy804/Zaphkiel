{
  writers,
  gawk,
}: let
  interpreter = "${gawk}/bin/awk -f";
in
  writers.makeScriptWriter {
    inherit interpreter;
    check = interpreter;
  }
