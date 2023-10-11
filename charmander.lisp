;;;;
;;;; CHARMANDER.LISP
;;;;
;;;; Oliver Delancey
;;;;
;;;; This file is a component of Project Charmander.
;;;; See LICENSE for usage permissions, limitations, and conditions.
;;;;

(in-package #:charmander)

(interpol:enable-interpol-syntax)


;;; C0 Control Codes

(defun-ex bell ()
  "Makes an audible noise"
  (format t #?"\a"))

(defun-ex tab ()
  "Position to the next character tab stop"
  (format t #?"\t"))

(defun-ex line-feed ()
  "Move the cursor down one row"
  (format t #?"\n"))

(defun-ex line-tabulation ()
  "Position the form at the next line tab stop"
  (format t #?"\v"))

(defun-ex form-feed ()
  "On printers, load next page.
   In some terminal emulators, clear the screen."
  (format t #?"\f"))

(defun-ex carriage-return ()
  "Move cursor to column zero"
  (format t #?"\r"))


;;; Control Sequence Introducer (CSI) Sequences

(defun-ex cursor-up (&optional (n 1))
  "Move cursor N cells up (default 1)"
  (format t #?"\e[~aA" n))

(defun-ex cursor-down (&optional (n 1))
  "Move cursor N cells down (default 1)"
  (format t #?"\e[~aB" n))

(defun-ex cursor-forward (&optional (n 1))
  "Move cursor N cells forward (default 1)"
  (format t #?"\e[~aC" n))

(defun-ex cursor-back (&optional (n 1))
  "Move cursor N cells back (default 1)"
  (format t #?"\e[~aD" n))

(defun-ex cursor-position (&optional (n 1) (m 1))
  "Move the cursor to row N column M (default 1, 1)
   The values are 1-based, 1,1 being top left corner."
  (format t #?"\e[~a;~aH" n m))

(defun-ex erase-display (&optional (n 0))
  "Clears part of the screen.
   N = 0 : Clear from cursor to end of screen. (default)
   N = 1 : Clear from cursor to beginning of screen.
   N = 2 : Clear entire screen.
   N = 3 : Clear entire screen and delete all lines saved in the scrollback buffer.
           This was added for xterm and is supported by other terminals."
   (format t #?"\e[~aJ" n))

(defun-ex erase-line (&optional (n 0))
  "Erases part of the line. Cursor position does not change.
   N = 0 : Clear from cursor to end of line. (default)
   N = 1 : Clear from cursor to beginning of line.
   N = 2 : Clear entire line."
   (format t #?"\e[~aK" n))

(defun-ex scroll-up (&optional (n 1))
  "Scroll whole page up by N lines (default 1)
   New lines are added at the bottom."
   (format t #?"\e[~aS" n))

(defun-ex scroll-down (&optional (n 1))
  "Scroll whole page down by N lines (default 1)
   New lines are added at the top."
   (format t #?"\e[~aT" n))

(defun-ex horizontal-vertical-position (&optional (n 1) (m 1))
  "Same as CURSOR-POSITION, but counts as a format effector like CR or LF
   rather than an editor function like CURSOR-UP."
   (format t #?"\e[~a;~af" n m))

(defun-ex save-cursor-position ()
  "Save current cursor position."
  (format t #?"\e[s"))

(defun-ex restore-cursor-position ()
  "Restore saved cursor position."
  (format t #?"\e[u"))

(defun-ex enable-alt-screen-buffer ()
  "Enable alternative screen buffer."
  (uiop:run-program "tput smcup" :output t))

(defun-ex disable-alt-screen-buffer ()
  "Disable alternative screen buffer."
  (uiop:run-program "tput rmcup" :output t))


(defun-ex sgr (n)
  "Select Graphic Rendition. Sets display attributes.

  0       : Reset or normal. All attributes are turned off.
  1       : Bold/increased intensity.
  2       : Faint/decreased intensity/dim.
  3       : Italic. Not common, sometimes inverse or blink.
  4       : Underline.
  5       : Slow blink (<150 times per minute).
  6       : Rapid blink (>150 times per minute). Not widely supported.
  7       : Reverse video/invert. Swap bg and fg.
  8       : Conceal/hide. Not widely supported.
  9       : Crossed-out/strike.
  10      : Primary/default font.
  11-19   : Select alternative font N-10.
  20      : Fraktur (Gothic). Not widely supported.
  21      : Double underline OR 'not' bold.
  22      : Normal intensity.
  23      : Neither italic nor blackletter.
  24      : Not underlined.
  25      : Not blinking. Turn blinking off.
  26      : Proportional spacing. Not known to be used, see ITU T.61 and T.416.
  27      : Not reversed.
  28      : Reveal/not concealed.
  29      : Not crossed out.
  30-37   : Set foreground color. See tables below.
  38      : Set foreground color. Followed by 5;n or 2;r;g;b.
  39      : Default foreground color.
  40-47   : Set background color.
  48      : Set background color. Followed by 5;n or 2;r;g;b.
  49      : Default background color.
  50      : Disable proportional spacing. T.61 and T.416.
  51      : Framed. ???
  52      : Circled. ???
  53      : Overlined.
  54      : Neither framed for encircled.
  55      : Not overlined.
  56-57   : UNDEFINED
  58      : Set underline color. Not standard, but implemented in Kitty, VTE, 
            mintty, and iTerm2. Followed by 5;n or 2;r;g;b.
  59      : Default underline color. Not standard, but implemented in Kitty, VTE, 
            mintty, and iTerm2.
  60-65   : Ideogram control sequences, rarely used.
  66-72   : UNDEFINED
  73-75   : mintty only, superscripts and subscripts.
  90-97   : Set bright foreground color. Followed by 5;n or 2;r;g;b.
  100-107 : Set bright background color. Followed by 5;n or 2;r;g;b.


  COLORS

  3/4 BIT
  Colors can be specified with ESC[<fg>;<bg>m. This is the standard to use to
  keep your application consistent with the coloring of the host terminal.
  
  FG  BG  NAME
  -------------------------
  30  40  Black
  31  41  Red
  32  42  Green
  33  43  Yellow
  34  44  Blue
  35  45  Magenta
  36  46  Cyan
  37  47  White
  90  100 Bright black/gray
  91  101 Bright red
  92  102 Bright green
  93  103 Bright yellow
  94  104 Bright blue
  95  105 Bright magenta
  96  106 Bright cyan
  97  107 Bright white

  8 BIT
  Not a very useful standard, as it is more limited than 24-bit and far less
  intuitive than 3/4-bit. Colors can be specified with ESC[38;5nm for foreground
  and ESC[48:5nm for background, where n is a number from the 256-color lookup 
  table. See online resources for reference tables.

  24 BIT
  Colors can be specified with ESC[38;2;r;g;bm for foreground and ESC[48;2;r;g;bm
  for background, where r, g, and b represent a 24-bit base-10 color triplet."
  (format t #?"\e[~am" n))

