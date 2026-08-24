{ inputs, lib, ... }:
let
  # robbyrussell / starship-default palette:
  #   green ➜ arrow, cyan cwd, purple git branch, red dirty, yellow duration
  theme = builtins.toJSON {
    name = "russell";
    vars = {
      green = "#5fd787";
      cyan = "#5fd7d7";
      red = "#ff5f5f";
      yellow = "#ffd787";
      purple = "#af5fd7";
      blue = "#87afd7";
      grey = "#626262";
      darkgrey = "#3a3a3a";
      fg = "";
    };
    colors = {
      accent = "green";
      border = "darkgrey";
      borderAccent = "green";
      borderMuted = "grey";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "grey";
      dim = 240;
      text = "";
      thinkingText = "grey";

      selectedBg = "darkgrey";
      userMessageBg = "#1c1c1c";
      userMessageText = "";
      customMessageBg = "#262626";
      customMessageText = "";
      customMessageLabel = "cyan";
      toolPendingBg = "#1c1c1c";
      toolSuccessBg = "#1a2b20";
      toolErrorBg = "#2b1a1a";
      toolTitle = "cyan";
      toolOutput = "grey";

      mdHeading = "green";
      mdLink = "cyan";
      mdLinkUrl = "grey";
      mdCode = "fg";
      mdCodeBlock = "fg";
      mdCodeBlockBorder = "grey";
      mdQuote = "grey";
      mdQuoteBorder = "grey";
      mdHr = "grey";
      mdListBullet = "green";

      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "grey";

      syntaxComment = "grey";
      syntaxKeyword = "purple";
      syntaxFunction = "blue";
      syntaxVariable = "cyan";
      syntaxString = "green";
      syntaxNumber = "yellow";
      syntaxType = "cyan";
      syntaxOperator = "purple";
      syntaxPunctuation = "grey";

      thinkingOff = 240;
      thinkingMinimal = "grey";
      thinkingLow = "blue";
      thinkingMedium = "cyan";
      thinkingHigh = "purple";
      thinkingXhigh = "red";
      bashMode = "cyan";
      pythonMode = "purple";

      statusLineBg = "#1c1c1c";
      statusLineSep = "darkgrey";
      statusLineModel = "purple";
      statusLinePath = "cyan";
      statusLineGitClean = "green";
      statusLineGitDirty = "red";
      statusLineContext = "blue";
      statusLineSpend = "cyan";
      statusLineStaged = "green";
      statusLineDirty = "yellow";
      statusLineUntracked = "red";
      statusLineOutput = "cyan";
      statusLineCost = "yellow";
      statusLineSubagents = "purple";
    };
    symbols.preset = "nerd"; # JetBrainsMono Nerd Font is already your kitty font
  };

  # ~/.omp/agent/keybindings.yml — run /hotkeys in a session to see active
  # chords; disable an action by mapping it to [ ].
  # Shift+Tab (thinking.cycle) collides with shell/vim muscle memory.
  # Ctrl+L never reaches omp under kitty (bound to next_window).
  keybindings = {
    "app.model.cycleForward" = "Ctrl+P";
    "app.model.cycleBackward" = "Shift+Ctrl+P";
    "app.model.selectTemporary" = "Alt+P";
    "app.model.select" = "Alt+M";
    "app.plan.toggle" = "Alt+Shift+P";

    "app.history.search" = "Ctrl+R";
    "app.editor.external" = "Ctrl+G";

    "app.tools.expand" = "Ctrl+O";
    "app.tools.toggleVisibility" = "Ctrl+Shift+O";
    "app.thinking.toggle" = "Ctrl+T";
    "app.thinking.cycle" = "Alt+T";

    "app.message.followUp" = [ "Ctrl+Q" "Ctrl+Enter" ];
    "app.message.dequeue" = [ "Alt+Up" "Shift+Up" ];
    "app.retry" = "Alt+R";

    "app.clipboard.copyLine" = "Alt+Shift+L";
    "app.clipboard.copyPrompt" = "Alt+Shift+C";
    "app.clipboard.pasteTextRaw" = [ "Ctrl+Shift+V" "Alt+Shift+V" ];

    "app.live.toggle" = "Alt+L";
    "app.display.reset" = "Alt+Shift+R";
    "app.agents.hub" = "Alt+A";
  };
in
{
  imports = [ inputs.omp.homeManagerModules.default ];

  programs.omp = {
    enable = true;
    settings = {
      theme.dark = "russell"; # ~/.omp/agent/themes/russell.json below
      symbolPreset = "nerd";
    };
  };

  home.file = {
    ".omp/agent/themes/russell.json".text = theme;
    ".omp/agent/keybindings.yml".text =
      lib.generators.toYAML { } keybindings;
  };
}
