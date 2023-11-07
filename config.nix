{pkgs ? import <nixpkgs> {}}: let
  templ = pkgs.buildGoModule rec {
    pname = "templ";
    version = "0.2.334";

    src = pkgs.fetchFromGitHub {
      owner = "a-h";
      repo = "templ";
      rev = "v${version}";
      sha256 = "sha256-liELstdoh0/KaOY8TnjCmTgp2CYWk9rZnMuK1RUb3OM=";
    };

    vendorSha256 = "sha256-7QYF8BvLpTcDstkLWxR0BgBP0NUlJ20IqW/nNqMSBn4=";

    ldflags = ["-s" "-w" "-X=github.com/a-h/templ.Version=${version}"];

    subPackages = ["cmd/templ"];

    meta = with pkgs.lib; {
      description = "A language for writing HTML user interfaces in Go. ";
      homepage = "https://github.com/a-h/templ";
      license = licenses.mit;
      mainProgram = "templ";
    };
  };
in {
  ignore = [".idea/" "result" "node_modules/" "dist/"];
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
      file-picker = {hidden = false;};
      indent-guides = {
        render = true;
        skip-levels = 1;
      };
      soft-wrap = {enable = true;};
      statusline = {
        right = [
          "version-control"
          "diagnostics"
          "selections"
          "position"
          "file-encoding"
        ];
      };
      lsp = {display-messages = true;};
    };
    keys = {
      normal = {
        space = {
          q = ":quit";
          Q = ":quit!";
          w = ":write";
          W = ":write!";
        };
        C-c = ":config-open";
        C-r = ":config-reload";
        "C-/" = "toggle_comments";
        S-right = "goto_next_buffer";
        S-left = "goto_previous_buffer";
        C-b = ":buffer-close";
        C-s = ["select_all" "select_regex"];

        C-j = "shrink_selection";
        C-k = "expand_selection";
        C-l = "select_next_sibling";
        C-a = "select_all";
        C-u = ["half_page_up" "align_view_center"];
        C-d = ["half_page_down" "align_view_center"];

        "{" = ["goto_prev_paragraph" "collapse_selection"];
        "}" = ["goto_next_paragraph" "collapse_selection"];
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        G = "goto_file_end";
        "%" = "match_brackets";
        V = ["select_mode" "extend_to_line_bounds"];
        C = ["collapse_selection" "extend_to_line_end" "change_selection"];
        D = ["extend_to_line_end" "delete_selection"];
        S = "surround_add";

        d = {
          d = ["extend_to_line_bounds" "delete_selection"];
          t = ["extend_till_char"];
          s = ["surround_delete"];
          i = ["select_textobject_inner"];
          a = ["select_textobject_around"];
        };

        x = "delete_selection";
        p = "paste_clipboard_after";
        P = "paste_clipboard_before";
        y = [
          "yank_main_selection_to_clipboard"
          "normal_mode"
          "flip_selections"
          "collapse_selection"
        ];
        Y = [
          "extend_to_line_bounds"
          "yank_main_selection_to_clipboard"
          "goto_line_start"
          "collapse_selection"
        ];

        w = ["move_next_word_start" "move_char_right" "collapse_selection"];
        e = ["move_next_word_end" "collapse_selection"];
        b = ["move_prev_word_start" "collapse_selection"];

        i = ["insert_mode" "collapse_selection"];
        a = ["append_mode" "collapse_selection"];

        esc = ["collapse_selection" "keep_primary_selection"];
      };
      insert = {esc = ["collapse_selection" "normal_mode"];};
      select = {
        space = {
          j = {
            e = ":pipe jq";
            c = ":pipe jq -c";
          };
        };
        "{" = ["extend_to_line_bounds" "goto_prev_paragraph"];
        "}" = ["extend_to_line_bounds" "goto_next_paragraph"];
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        G = "goto_file_end";
        D = ["extend_to_line_bounds" "delete_selection" "normal_mode"];
        C = ["goto_line_start" "extend_to_line_bounds" "change_selection"];
        "%" = "match_brackets";
        S = "surround_add";

        i = "select_textobject_inner";
        a = "select_textobject_around";

        tab = ["insert_mode" "collapse_selection"];
        C-a = ["append_mode" "collapse_selection"];

        k = ["extend_line_up" "extend_to_line_bounds"];
        j = ["extend_line_down" "extend_to_line_bounds"];

        d = ["yank_main_selection_to_clipboard" "delete_selection"];
        x = ["yank_main_selection_to_clipboard" "delete_selection"];
        y = [
          "yank_main_selection_to_clipboard"
          "normal_mode"
          "flip_selections"
          "collapse_selection"
        ];
        Y = [
          "extend_to_line_bounds"
          "yank_main_selection_to_clipboard"
          "goto_line_start"
          "collapse_selection"
          "normal_mode"
        ];
        p = "replace_selections_with_clipboard";
        P = "paste_clipboard_before";

        esc = ["collapse_selection" "keep_primary_selection" "normal_mode"];
      };
    };
  };
  languages = with pkgs; {
    language = [
      {
        name = "go";
        formatter = {
          command = "sh";
          args = ["-c" "set -o pipefail; ${gotools}/bin/goimports | ${gofumpt}/bin/gofumpt"];
        };
      }
      {
        name = "lua";
        formatter = with nodePackages; {
          command = "${lua-fmt}/bin/luafmt";
          args = ["--stdin"];
        };
      }
      {
        name = "python";
        auto-format = true;
        formatter = with python311Packages; {
          command = "${black}/bin/black";
          args = ["--quiet" "-"];
        };
      }
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "${alejandra}/bin/alejandra";
          args = ["-qq"];
        };
      }
      {
        name = "templ";
        auto-format = true;
        formatter = {
          command = "${templ}/bin/templ";
          args = ["fmt"];
        };
      }
      {
        name = "typst";
        auto-format = true;
        scope = "source.typst";
        injection-regex = "typst";
        file-types = ["typ"];
        roots = [];
        comment-token = "//";
        formatter.command = "${typst-fmt}/bin/typstfmt";
        language-servers = ["typst"];
      }
    ];
    language-server = {
      typst.command = "${typst-lsp}/bin/typst-lsp";
      nil.config.nil.nix.flake.autoEvalInputs = true;
    };
  };
  themes = {
    catppuccin_frappe_transparent = {
      inherits = "catppuccin_frappe";
      "ui.background" = {};
    };
    catppuccin_latte_transparent = {
      inherits = "catppuccin_latte";
      "ui.background" = {};
    };
    catppuccin_macchiato_transparent = {
      inherits = "catppuccin_macchiato";
      "ui.background" = {};
    };
    catppuccin_mocha_transparent = {
      inherits = "catppuccin_mocha";
      "ui.background" = {};
    };
  };
  grammars = [
    {
      name = "typst";
      url = "https://github.com/uben0/tree-sitter-typst";
      rev = "791cac478226e3e78809b67ff856010bde709594";
      sha256 = "sha256-YI+EyLKvw1qg122aH1UCggTQtDT8TioSau6GGRwWktc=";
      queries = "queries";
    }
  ];
}
