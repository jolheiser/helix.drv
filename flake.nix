{
  description = "jolheiser helix derivation";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      tomlFormat = pkgs.formats.toml { };
      config = import ./config.nix { pkgs = pkgs; };
      buildGrammar =
        grammar:
        let
          source = pkgs.fetchgit {
            inherit (grammar) url rev sha256;
          };
          linkQueries = pkgs.lib.optionalString (builtins.hasAttr "queries" grammar) "cp -r ${source}/${grammar.queries} $out/queries";
        in
        pkgs.stdenv.mkDerivation {
          pname = "helix-tree-sitter-grammar-${grammar.name}";
          version = grammar.rev;
          buildInputs = [
            pkgs.helix
            pkgs.git
          ];
          src = source;
          dontInstall = true;
          buildPhase = ''
            runHook preBuild

            mkdir .helix
            cat << EOF > .helix/languages.toml
            use-grammars = { only = ["${grammar.name}"] }
            [[grammar]]
            name = "${grammar.name}"
            source = { git = "${grammar.url}", rev = "${grammar.rev}" }
            EOF

            mkdir -p runtime/grammars/sources
            cp -r ${source} runtime/grammars/sources/${grammar.name}
            export CARGO_MANIFEST_DIR=$(pwd)/.helix

            #hx -g fetch
            hx -g build

            mkdir $out
            cp runtime/grammars/${grammar.name}.so $out/${grammar.name}.so
            ${linkQueries}

            runHook postBuild
          '';
        };
      builtGrammars = builtins.map (grammar: {
        inherit (grammar) name;
        artifact = buildGrammar grammar;
      }) config.grammars;
      ignoreFile = pkgs.writeText "ignore" (builtins.concatStringsSep "\n" config.ignore);
      configFile = pkgs.writeText "config.toml" (
        builtins.readFile (tomlFormat.generate "helix-config" config.settings)
      );
      languageFile = pkgs.writeText "languages.toml" (
        builtins.readFile (tomlFormat.generate "helix-languages" config.languages)
      );
      themeFiles = pkgs.lib.mapAttrsToList (name: value: {
        inherit name;
        file = pkgs.writeText "${name}.toml" (
          builtins.readFile (tomlFormat.generate "helix-theme-${name}" value)
        );
      }) config.themes;
      themeLinks = builtins.map (
        theme: "ln -s ${theme.file} $out/home/helix/themes/${theme.name}.toml"
      ) themeFiles;
      grammarLinks = builtins.map (
        grammar: "ln -s ${grammar.artifact}/${grammar.name}.so $out/lib/runtime/grammars/${grammar.name}.so"
      ) builtGrammars;
      queryLinks = builtins.map (
        grammar: "ln -s ${grammar.artifact}/queries $out/lib/runtime/queries/${grammar.name}"
      ) builtGrammars;
    in
    {
      packages.x86_64-linux.default =
        pkgs.runCommand "hx"
          {
            buildInputs = with pkgs; [
              makeWrapper
            ];
          }
          ''
            mkdir $out
            ln -s ${pkgs.helix}/* $out
            rm $out/bin

            rm $out/lib
            mkdir -p $out/lib/runtime
            ln -s ${pkgs.helix}/lib/runtime/* $out/lib/runtime

            rm $out/lib/runtime/grammars
            mkdir $out/lib/runtime/grammars
            ln -s ${pkgs.helix}/lib/runtime/grammars/* $out/lib/runtime/grammars
            ${builtins.concatStringsSep "\n" grammarLinks}

            rm $out/lib/runtime/queries
            mkdir $out/lib/runtime/queries
            ln -s ${pkgs.helix}/lib/runtime/queries/* $out/lib/runtime/queries
            ${builtins.concatStringsSep "\n" queryLinks}

            mkdir -p $out/home/helix/themes
            ln -s ${configFile} $out/home/helix/config.toml
            ln -s ${languageFile} $out/home/helix/languages.toml
            ${builtins.concatStringsSep "\n" themeLinks}

            mkdir -p $out/home/git
            ln -s ${ignoreFile} $out/home/git/ignore

            makeWrapper ${pkgs.helix}/bin/hx $out/bin/hx \
              --set HELIX_RUNTIME $out/lib/runtime \
              --set XDG_CONFIG_HOME $out/home \
          '';
    };
}
