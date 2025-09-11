{
  pkgs,
  lib,
  ...
}:
lib.fix (this: {
  hello = pkgs.hello;
  default = this.hello;
})
