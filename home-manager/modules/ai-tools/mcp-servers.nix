# modules/ai-tools/mcp-servers.nix
#
# Central MCP server registry — shared across Claude Code, Gemini CLI, and Zed.
# Add a server here once; it propagates to all three tools automatically.
#
# Shape of each entry:
#   <name> = {
#     command = "node";                       # executable to run
#     args    = [ "/abs/path/to/server.js" ]; # arguments
#     env     = { TOKEN = "$MY_TOKEN"; };     # ⚠️ use env var refs, NEVER hardcode secrets
#   };
#
# Examples:
#   gitnexus = {
#     command = "node";
#     args    = [ "/Users/user/.claude/hooks/gitnexus/gitnexus-mcp.js" ];
#     env     = {};
#   };
{ ... }: {
  _module.args.mcpServers = {
    # --- add MCP servers here ---
  };
}
