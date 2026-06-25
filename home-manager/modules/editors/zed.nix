# modules/editors/zed.nix
#
# Generates ~/.config/zed/settings.json
# MCP servers from mcp-servers.nix are mapped into Zed's context_servers format.
#
# Zed on macOS is installed via the Zed website / Homebrew — this module only
# manages the config file. To have Nix install Zed as well, you could switch to:
#   programs.zed-editor.enable = true;
#   programs.zed-editor.userSettings = { ... };
#
# NOTE: This will replace ~/.config/zed/settings.json with a Nix store symlink
# (read-only). Back it up before running `home-manager switch` for the first time.
{ mcpServers, lib, ... }:
let
  # Map shared MCP servers into Zed's context_servers shape:
  #   { command = { path = "…"; args = […]; env = {…}; }; }
  contextServers = lib.mapAttrs (_name: srv: {
    command = {
      path = srv.command;
      args = srv.args or [ ];
      env  = srv.env  or { };
    };
  }) mcpServers;
in
{
  home.file.".config/zed/settings.json".text = builtins.toJSON (
    {
      # ─── Layout ──────────────────────────────────────────────────────────────
      diff_view_style           = "split";
      cli_default_open_behavior = "new_window";
      relative_line_numbers     = "enabled";
      vim_mode                  = true;
      buffer_font_size          = 16;

      project_panel       = { dock = "right"; };
      outline_panel       = { dock = "right"; };
      collaboration_panel = { dock = "right"; };
      git_panel           = { dock = "right"; };

      tab_bar = { show = false; };

      # ─── AI Agent servers (Zed registry-based, not MCP) ──────────────────────
      agent_servers = {
        cursor     = { type = "registry"; };
        claude-acp = { type = "registry"; };
        gemini     = { type = "registry"; };
      };

      # ─── AI Agent settings ───────────────────────────────────────────────────
      agent = {
        dock = "left";

        inline_assistant_model = {
          provider = "google";
          model    = "gemini-2.5-flash";
        };

        default_model = {
          enable_thinking = true;
          provider        = "google";
          model           = "gemini-3-pro-preview";
        };

        tool_permissions = {
          default = "confirm";
          tools = {
            read_file      = { default = "allow"; };
            list_directory = { default = "allow"; };
            grep           = { default = "allow"; };
            sed            = { default = "allow"; };
            cat            = { default = "allow"; };
            find_path      = { default = "allow"; };
            edit_file      = { default = "allow"; };
            terminal = {
              default = "confirm";
              always_allow = [
                { pattern = "^git\\s+(status|log|diff|branch)"; }
                { pattern = "^npm\\s+(install|test|run|build)"; }
                { pattern = "^cargo\\s+(build|test|check)"; }
              ];
              always_confirm = [
                { pattern = "sudo\\s"; }
                { pattern = "rm\\s+-rf"; }
              ];
            };
          };
        };
      };

      # ─── Telemetry ───────────────────────────────────────────────────────────
      telemetry = {
        diagnostics = false;
        metrics     = false;
      };

      # ─── Vim ─────────────────────────────────────────────────────────────────
      vim = { use_system_clipboard = "never"; };

      # ─── LSP ─────────────────────────────────────────────────────────────────
      lsp = {
        pyright = {
          settings = {
            "python.analysis" = { diagnosticMode = "workspace"; };
          };
        };
      };
    }
    # Only emit context_servers when MCP servers are actually defined
    // lib.optionalAttrs (contextServers != { }) {
      context_servers = contextServers;
    }
  );
}
