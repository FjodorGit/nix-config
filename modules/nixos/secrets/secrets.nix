let
  me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEmu3RKLj4DK1EE1m+tOFC/JK4Lj+oALkXP3O2pg3qk1";
  server-me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdRFcvfr5wVEHsiCPNLLE+u7lQr6geFcTRwAWAzWlnG";
  server-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGd+HW+74KyJ6Q5SpsWdiihc5hLIeNw9zfdV1V9x70Jf";
in
{
  "wgcf-private.age".publicKeys = [
    me
    server-me
    server-host
  ];
}
