{ pkgs, config, lib, inputs, ... }:

{
  services.xserver.windowManager = {
    dwm.enable = true;
  };

#     dwm.package = pkgs.dwm.override {
#       conf = ''
# /* --=[ Custom themes variables ]--= */
#
# static const unsigned int borderpx = 2; /* border pixel of windows */
# static const unsigned int snap = 32; /* snap pixel */
# static const unsigned int gappx = 3; /* gaps between windows */
#
# /* bar settings */
# static const int showbar = 1; /* 0 means no bar */
# static const int topbar = 1; /* 0 means bottom bar */
#
# /* colors variables */
# static char bgcolor[] = "#191724"; /* background color */
# static char fgcolor[] = "#e0def4"; /* foreground color */
# static char selfbgcolor[] = "#191724"; /* active background color */
# static char selfgcolor[] = "#e0def4"; /* active foreground color */
#
# static const char base[] = "#191724"; /* black */
# static const char surface[] = "#1f1d2e"; /* dark grey */
# static const char text[] = "#e0def4"; /* white */
# static const char love[] = "#eb6f92"; /* redish */
# static const char rose[] = "#ebbcba"; /* pink */
# static const char pine[] = "#31748f"; /* blue */
#
# static char *colors[][3] = {
#     /*                      fg          bg          border   */
#     [SchemeNorm]    = {     surface,    base,       rose     },
#     [SchemeSel]     = {     surface,    base,       love     },
#     [SchemeStatus]  = {     text,       base,       base     },
#     [SchemeStatus]  = {     text,       pine,       surface  }, // Right
#     [SchemeTagsSel] = {     text,       base,       surface  }, // Left
#     [SchemeTagsNorm]= {     text,       base,       surface  }, // Left
#     [SchemeInfoSel] = {     text,       base,       surface  }, // Middle
#     [SchemeInfoNorm]= {     text,       base,       surface  }, // Middle
# };
#
# /* fonts */
# static const char *fonts[] = {
#   Ostrich Sans:pixelsize=16:antialias=true:autohint=true,
#   Font Awesome 5 Free Solid:pixelsize=16:antialias=true:autohint=true,
# };
# static const char dmenufont[] = "Ostrich Sans:pixelsize=16:antialias=true:autohint=true";
#
# typedef struct {
# 	const char *name;
# 	const void *cmd;
# } Sp;
# const char *spcmd1[] = {TERMINAL, "-n", "spterm", "-g", "120x34", NULL };
# const char *spcmd2[] = {TERMINAL, "-n", "spcalc", "-f", "monospace:size=16", "-g", "50x20", "-e", "bc", "-lq", NULL };
# static Sp scratchpads[] = {
# 	/* name          cmd  */
# 	{"spterm",      spcmd1},
# 	{"spranger",    spcmd2},
# };
#       '';
#       # patches = [ ./dwm-statuscolors.patch ];
#     };
#   };
}
