{ mode ? "raw" }:
  let
    ESC =
      if mode == "sh"
      then ''\e''
      else builtins.fromJSON ''"\x1b"''
    ;
  in {
    reset = "${ESC}[0m";
    bold = "${ESC}[1m";
    pale = "${ESC}[2m";
    italic = "${ESC}[3m";
    underline = "${ESC}[4m";
    blink = "${ESC}[5m";
    fast-blink = "${ESC}[6m";
    swap = "${ESC}[7m";
    hidden = "${ESC}[8m";
    strike = "${ESC}[9m";

    fg.black = "${ESC}[30m";
    fg.red = "${ESC}[31m";
    fg.green = "${ESC}[32m";
    fg.yellow = "${ESC}[33m";
    fg.blue = "${ESC}[34m";
    fg.magenta = "${ESC}[35m";
    fg.cyan = "${ESC}[36m";
    fg.white = "${ESC}[37m";

    fg.ansi256 = n: "${ESC}[38;5;${n}m";
    fg.rgb = r: g: b: "${ESC}[38;2;${r};${g};${b}m";

    fg.reset = "${ESC}[39m";

    fg.light_black = "${ESC}[90m";
    fg.light_red = "${ESC}[91m";
    fg.light_green = "${ESC}[92m";
    fg.light_yellow = "${ESC}[93m";
    fg.light_blue = "${ESC}[94m";
    fg.light_magenta = "${ESC}[95m";
    fg.light_cyan = "${ESC}[96m";
    fg.light_white = "${ESC}[97m";

    bg.black = "${ESC}[40m";
    bg.red = "${ESC}[41m";
    bg.green = "${ESC}[42m";
    bg.yellow = "${ESC}[43m";
    bg.blue = "${ESC}[44m";
    bg.magenta = "${ESC}[45m";
    bg.cyan = "${ESC}[46m";
    bg.white = "${ESC}[47m";

    bg.ansi256 = n: "${ESC}[48;5;${n}m";
    bg.rgb = r: g: b: "${ESC}[48;2;${r};${g};${b}m";

    bg.reset = "${ESC}[49m";

    bg.light_black = "${ESC}[100m";
    bg.light_red = "${ESC}[101m";
    bg.light_green = "${ESC}[102m";
    bg.light_yellow = "${ESC}[103m";
    bg.light_blue = "${ESC}[104m";
    bg.light_magenta = "${ESC}[105m";
    bg.light_cyan = "${ESC}[106m";
    bg.light_white = "${ESC}[107m";
  }
