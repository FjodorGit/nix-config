{ self, ... }:
let
  # Single source of truth for all terminal coding agents.
  rules = "${self}/modules/home/cli/agent-rules.md";
  effort = "medium";
in
{
  home.file = {
    ".claude/CLAUDE.md".source = rules; # Claude Code
    ".codex/AGENTS.md".source = rules; # Codex
    ".pi/agent/AGENTS.md".source = rules; # pi

    ".claude/settings.json".text = builtins.toJSON {
      effortLevel = effort;
      env.CLAUDE_CODE_EFFORT_LEVEL = effort;
      tui = "fullscreen";
      editorMode = "vim";
      model = "sonnet";
      skipAutoPermissionPrompt = true;
      permissions = {
        allow = [ "Bash" ];
        deny = [
          "Bash(rm -rf *)"
          "Bash(git push --force*)"
        ];
      };
    };
  };
}
