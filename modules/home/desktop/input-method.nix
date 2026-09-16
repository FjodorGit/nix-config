{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    noto-fonts-cjk-sans # CJK glyphs for the pinyin candidates
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs.qt6Packages; [
        fcitx5-chinese-addons
      ];
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us"; # item 0 is the off position of Ctrl+Space
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "pinyin";
      };
    };
  };
}
