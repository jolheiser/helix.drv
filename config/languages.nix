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
      language-servers = [
        "ruff"
        "ty"
      ];
      auto-format = true;
      formatter = {
        args = [
          "format"
          "-"
        ];
        command = "${lib.getExe ruff}";
      };
    }
  ];
  language-server = {
    nil.config.nil.nix.flake.autoEvalInputs = true;
    ruff = {
      command = "${lib.getExe ruff}";
      args = [ "server" ];
    };
    ty = {
      command = "${lib.getExe ty}";
      args = [ "server" ];
    };
    colors.command = "${lib.getExe uwu-colors}";
    grammar = {
      command = "${lib.getExe harper}";
      args = [ "--stdio" ];
    };
  };
}
