{ config, ... }:
let
  # Path to this nixbox repo on your machine
  nixboxPath = "/Users/user/nixbox";
  skillsDir = "${nixboxPath}/home-manager/modules/ai-tools/skills";
in
{
  # Symlink Claude skills
  home.file.".claude/commands".source = config.lib.file.mkOutOfStoreSymlink "${skillsDir}/claude";

  # Symlink Gemini skills as a 'personal' extension
  home.file.".gemini/extensions/personal".source = config.lib.file.mkOutOfStoreSymlink "${skillsDir}/gemini";

  # Symlink Opencode skills
  home.file.".config/opencode/skills".source = config.lib.file.mkOutOfStoreSymlink "${skillsDir}/opencode";
}
