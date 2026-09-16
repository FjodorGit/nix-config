# Plain helper, not a home-manager module: single source of truth for the
# terminal and the app commands spawned from both the niri binds (niri.nix)
# and the xremap chords (services.nix).
{
  lib,
  pkgs,
  inputs,
}:
let
  terminal = lib.getExe pkgs.foot;
  # foot takes a bare command, so no -e needed.
  inTerminal = pkg: [
    terminal
    (lib.getExe pkg)
  ];
in
{
  inherit terminal;

  calculator = inTerminal pkgs.sage;
  bluetooth = inTerminal pkgs.bluetuith;
  # nmrs-gui is a GTK4 app, so it gets no terminal.
  network = [ (lib.getExe inputs.nmrs.packages.${pkgs.stdenv.hostPlatform.system}.default) ];
}
