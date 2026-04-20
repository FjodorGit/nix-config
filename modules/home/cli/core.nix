{ self, ... }:
{
  programs.home-manager.enable = true;
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.file.".local/bin/newproj" = {
    source = "${self}/templates/new-project.sh";
    executable = true;
  };
}
