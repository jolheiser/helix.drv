{
  pkgs ? import <nixpkgs> { },
}:
{
  ignore = [
    ".idea/"
    "result"
    "node_modules/"
    "dist/"
  ];
  settings = {
    theme = "catppuccin_mocha_transparent";
    editor = {
      line-number = "relative";
      mouse = false;
      bufferline = "always";
      color-modes = true;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      file-picker.hidden = false;
      indent-guides = {
        render = true;
        skip-levels = 1;
      };
      soft-wrap.enable = true;
      statusline = {
        right = [
          "version-control"
          "diagnostics"
          "selections"
          "position"
          "file-encoding"
        ];
      };
      end-of-line-diagnostics = "hint";
      inline-diagnostics.cursor-line = "error";
      lsp.display-messages = true;
    };
    keys = import ./keys.nix { inherit pkgs; };
  };
  languages = import ./languages.nix { inherit pkgs; };
  themes = import ./themes.nix { inherit pkgs; };
  grammars = import ./grammars.nix { inherit pkgs; };
}
