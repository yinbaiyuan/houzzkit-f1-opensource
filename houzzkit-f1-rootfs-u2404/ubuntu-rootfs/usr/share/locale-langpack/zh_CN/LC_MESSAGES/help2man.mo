Þ    2      ¬  C   <      H     I     O     k  !        ¦     ¿     Ø  &   õ          #  ¼   0  Ê   í  ²   ¸  	   k     u                    ¢     «     ±  Y  ·     	     	  "   %	  ¶   H	     ÿ	     
     
  Á   
     Ö
  ì   W     D  1   S                 Ú   ·  B     1   Õ       5         V     \     j  Þ  v  )   U            Ù       b     h     {  '        ½     Ù     ø  !        8  	   ?  ©   I  ©   ó          /     6     =     D     K     R     Y     `  e  g     Í     Ô  !   á               ¤     «     ²     O  Ö   ä     »  ¯   Î     ~            ¬   ¥  4   R  '     D   ¯  A   ô     6     =     J    d  *   ê#     $     $                       	   (                                             1   +   2   -          
      &      %   #          $                   !               0                  *   '                   "   ,           .   )            /    %B %Y %s \- manual page for %s %s %s: can't create %s (%s) %s: can't get `%s' info from %s%s %s: can't open `%s' (%s) %s: can't unlink %s (%s) %s: error writing to %s (%s) %s: no valid information found in `%s' AUTHOR AVAILABILITY Additional material may be included in the generated output with the
.B \-\-include
and
.B \-\-opt\-include
options.  The format is simple:

    [section]
    text

    /pattern/
    text
 Any
.B [NAME]
or
.B [SYNOPSIS]
sections appearing in the include file will replace what would have
automatically been produced (although you can still override the
former with
.B \-\-name
if required).
 Blocks of verbatim *roff text are inserted into the output either at
the start of the given
.BI [ section ]
(case insensitive), or after a paragraph matching
.BI / pattern /\fR.
 COPYRIGHT DESCRIPTION ENVIRONMENT EXAMPLES Environment Examples FILES Files GNU %s %s

Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2009, 2010,
2011, 2012, 2013, 2014, 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Written by Brendan O'Dea <bod@debian.org>
 Games INCLUDE FILES Include file for help2man man page Lines before the first section or pattern which begin with `\-' are
processed as options.  Anything else is silently ignored and may be
used for comments, RCS keywords and the like.
 NAME OPTIONS Options Other sections are prepended to the automatically produced output for
the standard sections given above, or included at
.I other
(above) in the order they were encountered in the include file.
 Patterns use the Perl regular expression syntax and may be followed by
the
.IR i ,
.I s
or
.I m
modifiers (see
.BR perlre (1)).
 Placement of the text within the section may be explicitly requested by using
the syntax
.RI [< section ],
.RI [= section ]
or
.RI [> section ]
to place the additional text before, in place of, or after the default
output respectively.
 REPORTING BUGS Report +(?:[\w-]+ +)?bugs|Email +bug +reports +to SEE ALSO SYNOPSIS System Administration Utilities The full documentation for
.B %s
is maintained as a Texinfo manual.  If the
.B info
and
.B %s
programs are properly installed at your site, the command
.IP
.B info %s
.PP
should give you access to the complete manual.
 The latest version of this distribution is available on-line from: The section output order (for those included) is: This +is +free +software Try `--no-discard-stderr' if option outputs to stderr Usage User Commands Written +by `%s' generates a man page out of `--help' and `--version' output.

Usage: %s [OPTION]... EXECUTABLE

 -n, --name=STRING       description for the NAME paragraph
 -s, --section=SECTION   section number for manual page (1, 6, 8)
 -m, --manual=TEXT       name of manual (User Commands, ...)
 -S, --source=TEXT       source of program (FSF, Debian, ...)
 -L, --locale=STRING     select locale (default "C")
 -i, --include=FILE      include material from `FILE'
 -I, --opt-include=FILE  include material from `FILE' if it exists
 -o, --output=FILE       send output to `FILE'
 -p, --info-page=TEXT    name of Texinfo manual
 -N, --no-info           suppress pointer to Texinfo manual
 -l, --libtool           exclude the `lt-' from the program name
     --help              print this help, then exit
     --version           print version number, then exit

EXECUTABLE should accept `--help' and `--version' options and produce output on
stdout although alternatives may be specified using:

 -h, --help-option=STRING     help option string
 -v, --version-option=STRING  version option string
 --version-string=STRING      version string
 --no-discard-stderr          include stderr when parsing option output

Report bugs to <bug-help2man@gnu.org>.
 help2man \- generate a simple manual page or other Project-Id-Version: help2man 1.46.6
Report-Msgid-Bugs-To: Brendan O'Dea <bug-help2man@gnu.org>
PO-Revision-Date: 2015-10-10 07:51+0000
Last-Translator: Mingye Wang <arthur2e5@aosc.xyz>
Language-Team: Chinese (simplified) <i18n-zh@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:05+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
 %Y %B %s \- %s æå %s %sï¼æ æ³åå»º %s (%s) %s: æ æ³å¾å° `%s' ä¿¡æ¯ï¼ä» %s%s %sï¼æ æ³æå¼ `%s' (%s) %s: æ æ³åæ¶é¾æ¥ %s (%s) %sï¼åå¥ %s æ¶åºé (%s) %s: `%s' åæ¾ä¸å°ææä¿¡æ¯ ä½è å¯ç¨æ§ éå ææå¯ä»¥éè¿
.B \-\-include
å
.B \-\-opt\-include
éé¡¹å å¥çæçè¾åºãæ ¼å¼å¾ç®å

    [ç« è]
    æå­

    /æ­£åè¡¨è¾¾å¼/
    æå­
 å¨åå«æä»¶ä¸­çä»»ä½
.B [åç§°]
æ
.B [æè¦]
ç« èé½å°æ¿æ¢èªå¨çæçåå®¹ãå¦ææå¿è¦çè¯ï¼ä½ è¿æ¯å¯ä»¥ç¨
.B \-\-name
è¦çåèã
 éå­ *roff æå­åå°å¨ç»å®ç
.BI [ ç« è ]
ï¼å¤§å°åä¸ææï¼å¼å§å¤ï¼æå¨å¹é
.BI / æ­£åè¡¨è¾¾å¼ /
çæ®µåå å¥ã
 çæ æè¿° ç¯å¢ ç¤ºä¾ ç¯å¢ ç¤ºä¾ æä»¶ æä»¶ GNU %s %s

çæææ (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2009, 2010,
2011, 2012, 2013, 2014, 2015 èªç±è½¯ä»¶åºéä¼ã
æ¬è½¯ä»¶ä¸ºèªç±è½¯ä»¶ï¼åè§æºç ä»¥è·åååæ¡ä»¶ãæ¬è½¯ä»¶ä¸å«ä»»ä½ä¿è¯ï¼çè³ä¸å«å¯¹äºééæ§åå¯¹æä¸
ç¹å®ç¨éçéç¨æ§çä¿è¯ã

ä½è Brendan O'Dea <bod@debian.org>
 æ¸¸æ åå«æä»¶ help2man æåé¡µçåå«æä»¶ ç¬¬ä¸èåçè¡ï¼æç± `\-' å¼å§çæ¨¡å¼ï¼å°è¢«è®¤ä¸ºæ¯éé¡¹ã
å¶ä»çé½å°è¢«å®éå°å¿½ç¥ï¼å¯è¢«ç¨ä½æ³¨éãRCS å³é®å­ç­ã
 åç§° éé¡¹ éé¡¹ å¶ä»ç« èä¼èªå¨éå å°ä»¥ä¸èªå¨çæç« èä¹ä¸ï¼ææç§å®ä»¬å¨åå«æä»¶ä¸­åºç°çé¡ºåºåå«äº
.I å¶ä»
ï¼ä»¥ä¸ï¼ç« èåã
 æ­£åè¡¨è¾¾å¼æ¨¡å¼ä½¿ç¨ Perl æ­£åè¡¨è¾¾å¼è¯­æ³æå®ï¼å¹¶å¯ä»¥è·éå¦ä¸ä¿®é¥°ç¬¦ï¼
.IR i ,
.I s
æ
.I m
ï¼åè§
.BR perlre(1)
ï¼.
 æå­å¨ç« èä¸­çä½ç½®å¯åå«ç¨åå«ç¨ä»¥ä¸æ¹å¼æ¥ææï¼
.RI [< ç« è ],
.RI [= ç« è ]
æ
.RI [> ç« è ]
ï¼åå«å°éå æå­ç½®äºé»è®¤æå­ä¹åãæ¿ä»£é»è®¤æå­åç½®äºå¶åã
 æ¥åç¨åºè­è« Report +(?:[\w-]+ +)?bugs|Email +bug +reports +to|æ¥å(ç¨åº)?(éè¯¯|è­è«|bug)?(ç»|å°)?ï¼?|æ¥(é|bug)(ç»|å°)?ï¼?|å°(ç¨åº)?(éè¯¯|è­è«|bug)?æ¥å(ç»|å°)? åè§ æè¦ ç³»ç»ç®¡çå®ç¨å·¥å· .B %s
çå®æ´ææ¡£ä»¥ Texinfo æåçå½¢å¼ç»´æ¤ãè¥
.B info
å
.B %s
ç¨åºå¨ä½ å¤å·²å®è£å¦¥å½ï¼è¿è¡å½ä»¤
.IP
.B info %s
.PP
åºå¯æä¾å®æ´ææ¡£ã
 æ¬åè¡çææ°çæ¬å¯ä»¥å¨æ­¤å¤å¨çº¿æ¾å°: ç« èè¾åºï¼åå«çï¼é¡ºåºä¸ºï¼ This +is +free +software|(æ­¤|æ¬)(è½¯ä»¶)?ä¸º(èªç±|åè´¹)?è½¯ä»¶ å°è¯ `--no-discard-stderr' å¦æéé¡¹è¾åºå°äºæ åéè¯¯ ç¨æ³ ç¨æ·å½ä»¤ Written +by|ç¼è|ä½è `%s' æ ¹æ® `--help' å `--version' è¾åºçææåé¡µé¢ã

ç¨æ³ï¼%s [éé¡¹]... å¯æ§è¡ç¨åº

 -n, --name=STRING       åç§°æ®µè½çæè¿°
 -s, --section=SECTION   æåé¡µç« èå· (1, 6, 8)
 -m, --manual=TEXT       æåå (ç¨æ·å½ä»¤, ...)
 -S, --source=TEXT       ç¨åºæ¥æº (FSF, Debian, ...)
 -L, --locale=STRING     éæ©è¯­åº (é»è®¤ "C")
 -i, --include=FILE      ä» `FILE' åå«ææ
 -I, --opt-include=FILE  ä» `FILE' åå«ææè¥å¶å­å¨
 -o, --output=FILE       è¾åºå° `FILE'
 -p, --info-page=TEXT    Texinfo æåå
 -N, --no-info           ä¸è¾åºå° Texinfo æåçæç¤º
 -l, --libtool           ä»ç¨åºåä¸­å¿½ç¥ `lt-' åç¼
     --help              æå°æ­¤å¸®å©å¹¶éåº
     --version           æå°çæ¬å·å¹¶éåº

å¯æ§è¡ç¨åºåºæ¥çº³ `--help' å `--version' éé¡¹å¹¶è¾åºå°æ åè¾åºï¼å°½ç®¡ä½ ä¹å¯ä»¥è¿æ ·æå®æ¿ä»£:

 -h, --help-option=STRING     å¸®å©éé¡¹å­ä¸²
 -v, --version-option=STRING  çæ¬éé¡¹å­ä¸²
 --version-string=STRING      çæ¬å­ä¸²
 --no-discard-stderr          è§£æè¾åºæ¶åå«æ åéè¯¯

æ¥åéè¯¯ç» <bug-help2man@gnu.org>.
 help2man \- è¾åºä¸ä»½ç®åçæåé¡µ æè å¶å® 