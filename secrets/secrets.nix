let
  me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmu3RKLj4DK1EE1m+tOFC/JK4Lj+oALkXP3O2pg3qk1";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdRFcvfr5wVEHsiCPNLLE+u7lQr6geFcTRwAWAzWlnG";
in
{
  "wgcf-private.age".publicKeys = [
    me
    server
  ];
}
