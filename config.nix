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
    keys = {
      normal = {
        space = {
          q = ":quit";
          Q = ":quit!";
          w = ":write";
          W = ":write!";
          o = "file_picker_in_current_buffer_directory";
        };
        C-c = ":config-open";
        C-r = ":config-reload";
        "C-/" = "toggle_comments";
        S-right = "goto_next_buffer";
        S-left = "goto_previous_buffer";
        C-b = ":buffer-close";
        C-s = [
          "select_all"
          "select_regex"
        ];

        C-j = "shrink_selection";
        C-k = "expand_selection";
        C-l = "select_next_sibling";
        C-a = "select_all";
        C-u = [
          "half_page_up"
          "align_view_center"
        ];
        C-d = [
          "half_page_down"
          "align_view_center"
        ];

        "{" = [
          "goto_prev_paragraph"
          "collapse_selection"
        ];
        "}" = [
          "goto_next_paragraph"
          "collapse_selection"
        ];
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        G = "goto_file_end";
        "%" = "match_brackets";
        V = [
          "select_mode"
          "extend_to_line_bounds"
        ];
        C = [
          "collapse_selection"
          "extend_to_line_end"
          "change_selection"
        ];
        D = [
          "extend_to_line_end"
          "delete_selection"
        ];
        S = "surround_add";

        d = {
          d = [
            "extend_to_line_bounds"
            "delete_selection"
          ];
          t = [ "extend_till_char" ];
          s = [ "surround_delete" ];
          i = [ "select_textobject_inner" ];
          a = [ "select_textobject_around" ];
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

        w = [
          "move_next_word_start"
          "move_char_right"
          "collapse_selection"
        ];
        e = [
          "move_next_word_end"
          "collapse_selection"
        ];
        b = [
          "move_prev_word_start"
          "collapse_selection"
        ];

        i = [
          "insert_mode"
          "collapse_selection"
        ];
        a = [
          "append_mode"
          "collapse_selection"
        ];

        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
      insert = {
        esc = [
          "collapse_selection"
          "normal_mode"
        ];
      };
      select = {
        space = {
          j = {
            e = ":pipe jq";
            c = ":pipe jq -c";
          };
        };
        "{" = [
          "extend_to_line_bounds"
          "goto_prev_paragraph"
        ];
        "}" = [
          "extend_to_line_bounds"
          "goto_next_paragraph"
        ];
        "0" = "goto_line_start";
        "$" = "goto_line_end";
        "^" = "goto_first_nonwhitespace";
        G = "goto_file_end";
        D = [
          "extend_to_line_bounds"
          "delete_selection"
          "normal_mode"
        ];
        C = [
          "goto_line_start"
          "extend_to_line_bounds"
          "change_selection"
        ];
        "%" = "match_brackets";
        S = "surround_add";

        i = "select_textobject_inner";
        a = "select_textobject_around";

        tab = [
          "insert_mode"
          "collapse_selection"
        ];
        C-a = [
          "append_mode"
          "collapse_selection"
        ];

        k = [
          "extend_line_up"
          "extend_to_line_bounds"
        ];
        j = [
          "extend_line_down"
          "extend_to_line_bounds"
        ];

        d = [
          "yank_main_selection_to_clipboard"
          "delete_selection"
        ];
        x = [
          "yank_main_selection_to_clipboard"
          "delete_selection"
        ];
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

        esc = [
          "collapse_selection"
          "keep_primary_selection"
          "normal_mode"
        ];
      };
    };
  };
  languages = with pkgs; {
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
          command = "${lib.getExe' jsonnet "jsonnet"}";
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
    };
  };
  themes = {
    catppuccin_frappe_transparent = {
      inherits = "catppuccin_frappe";
      "ui.background" = { };
    };
    catppuccin_latte_transparent = {
      inherits = "catppuccin_latte";
      "ui.background" = { };
    };
    catppuccin_macchiato_transparent = {
      inherits = "catppuccin_macchiato";
      "ui.background" = { };
    };
    catppuccin_mocha_transparent = {
      inherits = "catppuccin_mocha";
      "ui.background" = { };
    };
  };
  grammars = [ ];
}
