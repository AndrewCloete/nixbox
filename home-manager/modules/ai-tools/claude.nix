# modules/ai-tools/claude.nix
#
# Generates ~/.claude/settings.json
# MCP servers are injected automatically from modules/ai-tools/mcp-servers.nix.
#
# NOTE: This file will replace ~/.claude/settings.json with a Nix store symlink.
# Back up the existing file before running `home-manager switch` for the first time.
{ mcpServers, ... }:
let
  # ⚠️ MACHINE-SPECIFIC PATH — this hook is only present on the aarch64-darwin machine.
  # If this config is reused elsewhere, update the path or parameterise it.
  gitnexusHook = "node \"/Users/user/.claude/hooks/gitnexus/gitnexus-hook.cjs\"";
in
{
  home.file.".claude/settings.json".text = builtins.toJSON {
    hooks = {
      PreToolUse = [
        {
          matcher = "Grep|Glob|Bash";
          hooks = [
            {
              type          = "command";
              command       = gitnexusHook;
              timeout       = 10;
              statusMessage = "Enriching with GitNexus graph context...";
            }
          ];
        }
      ];
      PostToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type          = "command";
              command       = gitnexusHook;
              timeout       = 10;
              statusMessage = "Checking GitNexus index freshness...";
            }
          ];
        }
      ];
    };
    # Populated from modules/ai-tools/mcp-servers.nix — empty until servers are added
    mcpServers = mcpServers;
  };
}
