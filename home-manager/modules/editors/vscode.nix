# modules/editors/vscode.nix
#
# Manages VSCode user settings via home.file (read-only Nix store symlink).
# VSCode on macOS is installed via the VSCode website / Homebrew — this module
# only manages the settings file, it does not install VSCode.
#
# To edit a setting: update this file, then run `home-manager switch`.
# The VSCode settings UI will warn about a read-only file — that is expected.
#
# Extensions are NOT managed by Nix (they are installed manually / via the
# VSCode marketplace). The full list is recorded below for reference:
#
# NOTE: This will replace ~/Library/Application Support/Code/User/settings.json
# with a Nix store symlink. Back it up before `home-manager switch` for the first time.
{ ... }:
{
  home.file."Library/Application Support/Code/User/settings.json".text =
    builtins.toJSON {

      # ─── Window ──────────────────────────────────────────────────────────────
      "window.openFilesInNewWindow"   = "off";
      "window.openFoldersInNewWindow" = "off";

      # ─── Security ────────────────────────────────────────────────────────────
      "security.promptForLocalFileProtocolHandling" = false;

      # ─── Explorer ────────────────────────────────────────────────────────────
      "explorer.confirmDelete"       = false;
      "explorer.confirmDragAndDrop"  = false;
      "explorer.fileNesting.patterns" = {
        # \${ is the Nix escape for a literal ${ in a double-quoted string
        "*.ts"          = "\${capture}.js";
        "*.js"          = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
        "*.jsx"         = "\${capture}.js";
        "*.tsx"         = "\${capture}.ts";
        "tsconfig.json" = "tsconfig.*.json";
        "package.json"  = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb, bun.lock";
        "Cargo.toml"    = "Cargo.lock";
        "*.sqlite"      = "\${capture}.\${extname}-*";
        "*.db"          = "\${capture}.\${extname}-*";
        "*.sqlite3"     = "\${capture}.\${extname}-*";
        "*.db3"         = "\${capture}.\${extname}-*";
        "*.sdb"         = "\${capture}.\${extname}-*";
        "*.s3db"        = "\${capture}.\${extname}-*";
      };

      # ─── Editor ──────────────────────────────────────────────────────────────
      "editor.fontFamily"                       = "Jetbrains Mono";
      "editor.lineNumbers"                      = "relative";
      "editor.minimap.enabled"                  = false;
      "editor.formatOnSave"                     = true;
      "editor.largeFileOptimizations"           = false;
      "editor.acceptSuggestionOnCommitCharacter" = false;

      # ─── Terminal ────────────────────────────────────────────────────────────
      "terminal.integrated.fontFamily" = "Jetbrains Mono";

      # ─── Workbench ───────────────────────────────────────────────────────────
      "workbench.editorAssociations" = {
        "*.ipynb"  = "jupyter-notebook";
        "*.drawio" = "vscode-drawio.editor";
      };
      "workbench.editor.showTabs" = "single";
      "workbench.colorTheme"      = "Gruvbox Dark Hard";

      # ─── Zen Mode ────────────────────────────────────────────────────────────
      "zenMode.hideStatusBar"   = false;
      "zenMode.hideLineNumbers" = false;

      # ─── Diff Editor ─────────────────────────────────────────────────────────
      "diffEditor.ignoreTrimWhitespace" = false;

      # ─── Files ───────────────────────────────────────────────────────────────
      "files.exclude" = {
        "**/.classpath"   = true;
        "**/.project"     = true;
        "**/.settings"    = true;
        "**/.factorypath" = true;
      };
      # ─── Search results ──────────────────────────────────────────────────────
      "[search-result]" = { "editor.lineNumbers" = "off"; };

      # ─── VIM (vscodevim.vim) ─────────────────────────────────────────────────
      "vim.timeout"       = 400;
      "vim.foldfix"       = true;
      "vim.leader"        = "<space>";
      "vim.handleKeys" = {
        "<C-a>" = false;
        "<C-s>" = false; # save
        "<C-f>" = false;
        "<C-k>" = false; # allows vscode folding; zM/zR still work
        "<C-2>" = false; # fold level 2
        "<C-3>" = false; # fold level 3
        "<C-4>" = false; # fold level 4
      };
      "vim.insertModeKeyBindings" = [
        { before = [ "j" "j" ]; after = [ "<Esc>" ]; }
      ];
      "vim.normalModeKeyBindingsNonRecursive" = [
        { before = [ "<leader>" "d"       ]; after    = [ "\"" "_" "d" ]; }
        { before = [ "Y"                  ]; after    = [ "y" "$" ]; }
        { before = [ "<leader>" "y"       ]; after    = [ "\"" "+" "y" ]; }
        { before = [ "<leader>" "<tab>"   ]; commands = [ "workbench.action.quickOpenPreviousRecentlyUsedEditorInGroup" ]; }
        { before = [ "<leader>" "g" "b"   ]; commands = [ "gitlens.toggleFileBlame" ]; }
        { before = [ "<leader>" "g" "s"   ]; commands = [ "workbench.view.scm" ]; }
        { before = [ "<leader>" "r" "n"   ]; commands = [ "editor.action.rename" ]; }
        { before = [ "<leader>" "b"       ]; commands = [ "workbench.view.explorer" ]; }
        { before = [ "<leader>" "s" "g"   ]; commands = [ "workbench.action.findInFiles" ]; }
        { before = [ "n" ]; after = [ "n" "z" "z" "z" "v" ]; }
        { before = [ "N" ]; after = [ "N" "z" "z" "z" "v" ]; }
        { before = [ "J" ]; after = [ "m" "z" "J" "`" "z" ]; }
        { before = [ "<leader>" "_"  ]; after = [ "8" "0" "i" "-" "<esc>" ]; }
        { before = [ "<leader>" "}"  ]; after = [ "/" "}" "<cr>" ]; }
        { before = [ "<leader>" "{"  ]; after = [ "?" "{" "<cr>" ]; }
        { before = [ "<leader>" "w"  ]; after = [ "\"" "+" "y" "i" "w" ]; }
        { before = [ "<leader>" "W"  ]; after = [ "\"" "+" "y" "i" "W" ]; }
        { before = [ "<leader>" "\"" ]; after = [ "\"" "+" "y" "i" "\"" ]; }
        # Both commands needed (when clause workaround)
        { before = [ "]" "c" ]; commands = [ "workbench.action.compareEditor.nextChange"     "workbench.action.editor.nextChange"     ]; }
        { before = [ "[" "c" ]; commands = [ "workbench.action.compareEditor.previousChange" "workbench.action.editor.previousChange" ]; }
        { before = [ "]" "d" ]; commands = [ "editor.action.marker.nextInFiles"  ]; }
        { before = [ "[" "d" ]; commands = [ "editor.action.marker.prevInFiles"  ]; }
      ];
      "vim.visualModeKeyBindingsNonRecursive" = [
        { before = [ "<leader>" "p" ]; after    = [ "\"" "_" "d" "P" ]; }
        { before = [ "<leader>" "y" ]; after    = [ "\"" "+" "y" ]; }
        { before = [ "<leader>" "d" ]; after    = [ "\"" "_" "d" ]; }
        { before = [ ">" ];            commands = [ "editor.action.indentLines"  ]; }
        { before = [ "<" ];            commands = [ "editor.action.outdentLines" ]; }
      ];

      # ─── Git / GitLens ───────────────────────────────────────────────────────
      "gitlens.codeLens.recentChange.enabled" = false;
      "gitlens.codeLens.authors.enabled"      = false;
      "gitlens.views.commits.files.layout"    = "tree";
      "gitlens.views.scm.grouped.views" = {
        commits          = true;
        branches         = true;
        remotes          = true;
        stashes          = true;
        tags             = true;
        worktrees        = true;
        contributors     = true;
        fileHistory      = false;
        repositories     = true;
        searchAndCompare = true;
        launchpad        = false;
      };
      "git.openRepositoryInParentFolders" = "always";

      # ─── Jupyter ─────────────────────────────────────────────────────────────
      "notebook.cellToolbarLocation"          = { "default" = "right"; "jupyter-notebook" = "left"; };
      "notebook.output.minimalErrorRendering" = true;
      "notebook.output.fontFamily"            = "Jetbrains Mono";
      "jupyter.askForKernelRestart"           = false;
      "jupyter.disableJupyterAutoStart"       = true;
      "interactiveWindow.executeWithShiftEnter" = true;
    };
}
