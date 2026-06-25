# modules/ai-tools/gemini.nix
#
# Generates ~/.gemini/settings.json
# MCP servers are injected automatically from modules/ai-tools/mcp-servers.nix.
#
# NOTE: This file will replace ~/.gemini/settings.json with a Nix store symlink.
# Back up the existing file before running `home-manager switch` for the first time.
{ mcpServers, lib, ... }:
{
  home.file.".gemini/settings.json".text = builtins.toJSON (
    {
      security = {
        auth = {
          # ⚠️ SECRET: The actual Gemini API key is provided at runtime via the
          # GEMINI_API_KEY environment variable — it is NOT stored in this file.
          selectedType = "gemini-api-key";
        };
      };
    }
    # Only add mcpServers block when servers are actually defined
    // lib.optionalAttrs (mcpServers != { }) {
      tools.mcpServers = mcpServers;
    }
  );
}
