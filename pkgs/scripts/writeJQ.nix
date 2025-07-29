{
  writers,
  jq,
}: let
  interpreter = "${jq}/bin/jq -f";
in
  writers.makeScriptWriter {
    inherit interpreter;
    check = interpreter;
  }
