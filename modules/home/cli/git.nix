{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "FjodorGit";
      user.email = "f.kholodkov@gmail.com";
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
      pull.merge = true;
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };
}
