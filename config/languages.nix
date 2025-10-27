{ pkgs }:
with pkgs;
{
  language = [
    {
      name = "go";
      formatter = {
        command = "sh";
        args = [
          "-c"
          "set -o pipefail; ${lib.getExe' gotools "goimports"} | ${lib.getExe gofumpt}"
        ];
      };
    }
    {
      name = "nix";
      auto-format = true;
      formatter = {
        command = "${lib.getExe nixfmt-rfc-style}";
        args = [ "-q" ];
      };
    }
    {
      name = "jsonnet";
      auto-format = true;
      formatter = {
        command = "${lib.getExe' jsonnet "jsonnetfmt"}";
        args = [ "-" ];
      };
    }
    {
      name = "python";
      auto-format = true;
      formatter = {
        args = [
          "format"
          "--stdin-filename"
          "file.py"
          "-"
        ];
        command = "${lib.getExe ruff}";
      };
      language-servers = [ "pylsp" ];
    }
  ];
  language-server = {
    nil.config.nil.nix.flake.autoEvalInputs = true;
    pylsp.config.pylsp = {
      plugins = {
        flake8.enabled = false;
        mypy = {
          dmypy = true;
          enabled = true;
          report_progress = true;
        };
        pycodestyle.enabled = false;
        pyflakes.enabled = false;
        ruff = {
          enabled = true;
          extendSelect = [ "I" ];
          format = [ "I" ];
        };
      };
    };
    colors.command = "${lib.getExe uwu-colors}";
  };
}
