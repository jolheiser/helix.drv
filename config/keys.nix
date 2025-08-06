{ pkgs }:
let
  caseMenu = with pkgs; {
    p = ":pipe ${lib.getExe sttr} pascal";
    c = ":pipe ${lib.getExe sttr} camel";
    k = ":pipe ${lib.getExe sttr} kebab";
    K = ":pipe ${lib.getExe sttr} kebab | ${lib.getExe sttr} upper";
    s = ":pipe ${lib.getExe sttr} snake";
    S = ":pipe ${lib.getExe sttr} snake | ${lib.getExe sttr} upper";
    u = ":pipe ${lib.getExe sttr} upper";
    l = ":pipe ${lib.getExe sttr} lower";
    t = ":pipe ${lib.getExe sttr} title";
  };
in
{
  normal = {
    "~" = caseMenu;
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
    "~" = caseMenu;
    space = {
      j = with pkgs; {
        e = ":pipe ${lib.getExe jq}";
        c = ":pipe ${lib.getExe jq} -c";
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
}
