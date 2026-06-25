# modules/ai-tools/opencode.nix
#
# Generates ~/.config/opencode/opencode.json
# MCP servers are injected automatically from modules/ai-tools/mcp-servers.nix.
{ mcpServers, ... }:
{
  home.file.".config/opencode/opencode.json".text = builtins.toJSON {
    # Populated from modules/ai-tools/mcp-servers.nix
    mcpServers = mcpServers;
    
    # Default settings (can be overridden here)
    # model = "anthropic/claude-3-5-sonnet";
    permissions = {
      skill = {
        "*" = "allow";
      };
    };
  };
}
