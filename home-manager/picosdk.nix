{ config
, pkgs
, ...
}: {
  home.sessionVariables = {
    # sessionVariables do no work for some reason. This is set in aarch.nix
    PICO_SDK_PATH = "/Users/user/Workspace/pico-sdk";
  };

  home.packages = with pkgs; [
    cmake
    gcc-arm-embedded
  ];


}
