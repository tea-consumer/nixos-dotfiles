{ pkgs, inputs, ... }:
let
  # This line makes all the Spicetify packages (themes, extensions) available
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Enable the Spicetify module
  programs.spicetify = {
    enable = true;
    # Choose a theme from the available set
    theme = spicePkgs.themes.hazy;

    # Enable some extensions
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle # Note: 'shuffle+' extension name is sanitized
    ];
  };
}