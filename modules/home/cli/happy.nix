{ pkgs, inputs, ... }:
let
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  # happy-coder ships a Node CLI that probes for Claude Code via `which
  # claude` and rejects anything whose resolved path isn't a .js/.cjs/.exe.
  # llm-agents ships claude-code as a compiled binary, so we bake
  # HAPPY_CLAUDE_PATH to bypass the probe.
  home.packages = [
    (pkgs.symlinkJoin {
      name = "happy-coder-wrapped";
      paths = [ llmAgents.happy-coder ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        for bin in $out/bin/*; do
          wrapProgram "$bin" \
            --set HAPPY_CLAUDE_PATH ${llmAgents.claude-code}/bin/claude
        done
      '';
    })
  ];
}
