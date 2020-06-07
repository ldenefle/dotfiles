{ config, lib, pkgs, ... }:

{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = false;
    };
  };
}
