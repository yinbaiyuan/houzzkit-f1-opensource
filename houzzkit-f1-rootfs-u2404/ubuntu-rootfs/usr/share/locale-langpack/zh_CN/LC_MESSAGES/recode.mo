Þ    P        k         È  K   É  »       Ñ  Ç   b	  8  *
  ³  c       |  ®  0   +  9   \  6     C   Í               6     U     i  9   r     ¬     Á     Ð     Ü  -   í  $     5   @  '   v  $     $   Ã  $   è          +  &   E     l       J     $   ç          "  H   0     y          ­     È     ä     í  "   ÿ     "  1   6     h  (   w           º     Ç  &   ä          &     ?  "   N     q  0        ½  (   Ô     ý         ­  "   D     g          
  &   )     P     e     ~  Ô     7   m     ¥  
   ª     µ     º  ³  Ã  N   w  Ú  Æ  n   ¡   û   !  i  "    v$  ò   &    ù&  =   )  =   D)  8   )  =   »)     ù)  &   *  '   )*     Q*  	   m*  9   w*     ±*     É*     Ø*     ä*  3   ÷*  0   ++  ;   \+  "   +  #   »+      ß+  /    ,  #   0,     T,  "   l,     ,     ­,  O   Â,  !   -     4-     M-  f   ]-     Ä-     â-  $   ÷-  %   .     B.     O.  1   n.      .  5   ³.     é.  9   ü.     6/     N/     [/  /   q/     ¡/     ¿/     Ô/  ,   ä/     0  )   '0     Q0  #   f0     0  ¤   0    <1  3   Å3     ù3     4  #   4  /   ½4     í4     5     5    ,5  8   .6     g6  	   n6     x6     }6        G       B   :   A   1      (   	          >              M   P       0             ;          F   !       '   .       $   3                     7   -         9   ,   *       #          5       E      )   2   4      @   ?       
       <           H                        +   =      C   D                  N          O       I   K   8          6                 &   J       "   L   %   /       
Copyright (C) 1990, 92, 93, 94, 96, 97, 99 Free Software Foundation, Inc.
 
Fine tuning:
  -s, --strict           use strict mappings, even loose characters
  -d, --diacritics       convert only diacritics or alike for HTML/LaTeX
  -S, --source[=LN]      limit recoding to strings and comments as for LN
  -c, --colons           use colons instead of double quotes for diaeresis
  -g, --graphics         approximate IBMPC rulers by ASCII graphics
  -x, --ignore=CHARSET   ignore CHARSET while choosing a recoding path
 
If a long option shows an argument as mandatory, then it is mandatory
for the equivalent short option also.  Similarly for optional arguments.
 
If none of -i and -p are given, presume -p if no FILE, else -i.
Each FILE is recoded over itself, destroying the original.  If no
FILE is specified, then act as a filter and recode stdin to stdout.
 
Listings:
  -l, --list[=FORMAT]        list one or all known charsets and aliases
  -k, --known=PAIRS          restrict charsets according to known PAIRS list
  -h, --header[=[LN/]NAME]   write table NAME on stdout using LN, then exit
  -F, --freeze-tables        write out a C module holding all tables
  -T, --find-subsets         report all charsets being subset of others
  -C, --copyright            display Copyright and copying conditions
      --help                 display this help and exit
      --version              output version information and exit
 
Operation modes:
  -v, --verbose           explain sequence of steps and report progress
  -q, --quiet, --silent   inhibit messages about irreversible recodings
  -f, --force             force recodings even when not reversible
  -t, --touch             touch the recoded files after replacement
  -i, --sequence=files    use intermediate files for sequencing passes
      --sequence=memory   use memory buffers for sequencing passes
 
Option -l with no FORMAT nor CHARSET list available charsets and surfaces.
FORMAT is `decimal', `octal', `hexadecimal' or `full' (or one of `dohf').
 
REQUEST is SUBREQUEST[,SUBREQUEST]...; SUBREQUEST is ENCODING[..ENCODING]...
ENCODING is [CHARSET][/[SURFACE]]...; REQUEST often looks like BEFORE..AFTER,
with BEFORE and AFTER being charsets.  An omitted CHARSET implies the usual
charset; an omitted [/SURFACE]... means the implied surfaces for CHARSET; a /
with an empty surface name means no surfaces at all.  See the manual.
 
Report bugs to <recode-bugs@iro.umontreal.ca>.
 
Usage: %s [OPTION]... [ [CHARSET] | REQUEST [FILE]... ]
   -p, --sequence=pipe     same as -i (on this system)
   -p, --sequence=pipe     use pipe machinery for sequencing passes
  done
  failed: %s in step `%s..%s'
 %s failed: %s in step `%s..%s' %s in step `%s..%s' %s to %s %sConversion table generated mechanically by Free `%s' %s %sfor sequence %s.%s *Unachievable* *mere copy* Ambiguous output Cannot complete table from set of known pairs Cannot invert given one-to-one table Cannot list `%s', no names available for this charset Charset %s already exists and is not %s Charset `%s' is unknown or ambiguous Child process wait status is 0x%0.2x Codes %3d and %3d both recode to %3d Dec  Oct Hex   UCS2  Mne  %s
 Expecting `..' in request Following diagnostics for `%s' to `%s' Format `%s' is ambiguous Format `%s' is unknown Free `recode' converts files between various character sets and surfaces.
 Identity recoding, not worth a table Internal recoding bug Invalid input LN is some language, it may be `c', `perl' or `po'; `c' is the default.
 Language `%s' is ambiguous Language `%s' is unknown Misuse of recoding library No character recodes to %3d No error No table to print No way to recode from `%s' to `%s' Non canonical input Pair no. %d: <%3d, %3d> conflicts with <%3d, %3d> Recoding %s... Recoding is too complex for a mere table Request `%s' is erroneous Request: %s
 Required argument is missing Resurfacer set more than once for `%s' Sequence `%s' is ambiguous Sequence `%s' is unknown Shrunk to: %s
 Sorry, no names available for `%s' Step initialisation failed Step initialisation failed (unprocessed options) Symbol `%s' is unknown Syntax is deprecated, please prefer `%s' System detected problem This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 Try `%s %s' for more information.
 UCS2   Mne   Description

 Unless DEFAULT_CHARSET is set in environment, CHARSET defaults to the locale
dependent encoding, determined by LC_ALL, LC_CTYPE, LANG.
 Unrecognised surface name `%s' Unsurfacer set more than once for `%s' Untranslatable input Virtual memory exhausted Virtual memory exhausted! With -k, possible before charsets are listed for the given after CHARSET,
both being tabular charsets, with PAIRS of the form `BEF1:AFT1,BEF2:AFT2,...'
and BEFs and AFTs being codes are given as decimal numbers.
 Written by Franc,ois Pinard <pinard@iro.umontreal.ca>.
 byte reversible ucs2 variable Project-Id-Version: recode 3.6
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2007-07-10 14:23+0000
Last-Translator: Meng Jie <Unknown>
Language-Team: Chinese (simplified) <i18n-zh@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:12+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
X-Poedit-Basepath: z:\recode-3.6
 
çæææ (C) 1990ï¼92ï¼93ï¼94ï¼96ï¼97ï¼99 èªç±è½¯ä»¶åºéä¼ã
 
ç»èè°æ´ï¼
  -sï¼--strict           å³ä½¿ä¸ºå¯æ¾æ¾çå­ç¬¦ä¹ä½¿ç¨ä¸¥æ ¼æ å°
  -dï¼--diacritics       åªä¸º HTML/LaTeX è½¬æ¢åé³è®°å·ç­
  -Sï¼--source[=è¯­è¨]    å°éæ°ç¼ç çèå´éå¶å¨æç¼ç¨è¯­è¨çå­ç¬¦ä¸²åæ³¨éä¸­
  -cï¼--colons           ä½¿ç¨åå·èä¸æ¯åå¼å·æ¥è¡¨ç¤ºåé³ç¬¦
  -gï¼--graphics         ç¨ ASCII ç¬¦å·æ¨¡æ IBMPC æ å°º
  -xï¼--ignore=å­ç¬¦é    å¨éæ©éæ°ç¼ç éå¾æ¶å¿½ç¥æå­ç¬¦é
 
é¿éé¡¹å¿é¡»å¸¦çåæ°å¨ä½¿ç¨ä¸ä¹ç­ä»·çç­éé¡¹æ¶ä¹æ¯å¿é¡»çãå¯éåæ°äº¦æ¯å¦æ­¤ã
 
å¦ææ²¡æç»åº -i æ -pï¼å½å½ä»¤è¡ä¸­ææä»¶æ¶ä½¿ç¨ -pï¼å¦åä½¿ç¨ -iã
ä¸ºæ¯ä¸ªæä»¶å°±å°éæ°ç¼ç ï¼ä¸¢å¼å¶åå§åå®¹ãå¦ææ²¡æå¨å½ä»¤è¡ä¸­æå®æä»¶ï¼
åå°æ åè¾å¥çåå®¹éæ°ç¼ç ä¸ºæ åè¾åºã
 
åè¡¨:
  -lï¼--list[=æ ¼å¼]          ååºæä¸ªæææå·²ç¥çå­ç¬¦éåå«å
  -kï¼--known=æ å°           ä»ååºå¹éå·²ç¥âæ å°âåè¡¨çå­ç¬¦é
  -hï¼--header[=[è¯­è¨/]è¡¨å] å¨æ åè¾åºä¸è¾åºç¬¦åæè¯­è¨è¯­æ³çè½¬æ¢è¡¨ï¼ç¶åéåº
  -Fï¼--freeze-tables        è¾åºä¸ä¸ªåæ¬ææè½¬æ¢è¡¨ç C æ¨¡å
  -Tï¼--find-subsets         æ¥åæææ¯å¶ä»å­ç¬¦éå­éçå­ç¬¦é
  -Cï¼--copyright            æ¾ç¤ºçæä¿¡æ¯åå¤å¶æ¡ä»¶
      --help                 æ¾ç¤ºæ¬å¸®å©ä¿¡æ¯åéåº
      --version              è¾åºçæ¬ä¿¡æ¯åéåº
 
æä½æ¨¡å¼ï¼
  -vï¼--verbose           æ¥åè½¬æ¢æ­¥éª¤åºååè¿ç¨
  -qï¼--quietï¼--silent   ä¸æ¥åä¸å¯éçéæ°ç¼ç 
  -fï¼--force             å¼ºå¶è¿è¡ä¸å¯éçéæ°ç¼ç 
  -tï¼--touch             å¨æ¿æ¢ä¹å touch éæ°ç¼ç çæä»¶
  -iï¼--sequence=files    ä¸ºç³»åè½¬æ¢ä½¿ç¨ä¸­é´æä»¶
      --sequence=memory   ä¸ºç³»åè½¬æ¢ä½¿ç¨åå­ç¼å²åº
 
éé¡¹ -l åå¦ææ²¡ææå®âæ ¼å¼âæâå­ç¬¦éâï¼åååºææå¯ç¨çå­ç¬¦éåå¤å¨ç¼ç ã
âæ ¼å¼âå¯ä»¥ä¸ºâdecimalâãâoctalâãâhexadecimalâæâfullâ(æèâdohfâ
ä¸­çä»»ä¸ä¸ªå­æ¯)ã
 
âè¯·æ±âæ ¼å¼ä¸ºâå­è¯·æ±[,å­è¯·æ±]...âï¼âå­è¯·æ±âæ ¼å¼ä¸ºâç¼ç [..ç¼ç ]...â
âç¼ç âæ ¼å¼ä¸ºâ[å­ç¬¦é][/[å¤å¨ç¼ç ]]...âï¼âè¯·æ±âä¸è¬æâæº..ç®çâçå½¢å¼ï¼
âæºâåâç®çâåä¸ºå­ç¬¦éåãå¦æçç¥âå­ç¬¦éâï¼åè¡¨ç¤ºéå¸¸çå­ç¬¦éï¼å¦æçç¥
â[/å¤å¨ç¼ç ]...âåè¡¨ç¤ºâå­ç¬¦éâé»è®¤çå¤å¨ç¼ç ï¼åªç»åºâ/âèå¨å¶åä¸ç»åºä»»
ä½å¤å¨ç¼ç åè¡¨ç¤ºæ²¡æä»»ä½å¤å¨ç¼ç ãè¯¦æè¯·åè§æåã
 
è¯·å <recode-bugs@iro.umontreal.ca> æ¥åç¨åºç¼ºé·ã
 
ç¨æ³ï¼%s [éé¡¹]... [ [å­ç¬¦é] | è¯·æ± [æä»¶]...]
   -pï¼--sequence=pipe     å¨æ­¤ç³»ç»ä¸ä¸ -i ç­æ
   -pï¼--sequence=pipe     ä¸ºç³»åè½¬æ¢ä½¿ç¨ç®¡éæºå¶
  å®æ
  å¤±è´¥ï¼%s å¨æ­¥éª¤â%s..%sâä¸­
 %s å¤±è´¥ï¼%s å¨æ­¥éª¤â%s..%sâä¸­ %s å¨æ­¥éª¤â%s..%sâä¸­ %s å° %s %sConversion table generated mechanically by Free `%s' %s %sä¸ºè½¬æ¢ç³»å %s.%s *æ æ³å°è¾¾* *ä»å¤å¶* ææ­§ä¹çè¾åº æ æ³ä»å·²ç¥æ å°éä¸­å½¢æå®æ´çè½¬æ¢è¡¨ æ æ³æ±åºç»å®çä¸ä¸å¯¹åºè½¬æ¢è¡¨çé æ æ³ååºâ%sâï¼æ­¤å­ç¬¦éæ²¡æå¯ç¨çå­ç¬¦å å­ç¬¦é %s å·²å­å¨ä¸å¹¶é %s å­ç¬¦éâ%sâæªç¥æææ­§ä¹ å­è¿ç¨ç­å¾ç¶æä¸º 0x%0.2x ä»£ç  %3d å %3d é½å°è¢«éæ°ç¼ç ä¸º %3d å   å«  åå­  UCS2  å©è®° %s
 è¯·æ±ä¸­è¦æâ..â â%sâå°â%sâçè¯æ­ä¿¡æ¯ æ ¼å¼â%sâæä¹ä¸æç¡® æ ¼å¼â%sâæªç¥ èªç±çârecodeâå°æä»¶å¨ä¸åçå­ç¬¦éåå¤å¨ç¼ç é´è½¬æ¢ã
 æç­åæ¢ï¼ä¸éè¦è½¬æ¢è¡¨ åé¨éæ°ç¼ç ç¼ºé· æ æçè¾å¥ âè¯­è¨âæ¯æç§ç¼ç è¯­è¨ï¼å¯ä»¥ä¸ºâcâãâperlâæâpoâï¼âcâä¸ºé»è®¤å¼ã
 è¯­è¨â%sâæä¹ä¸æç¡® è¯­è¨â%sâæªç¥ å¯¹éæ°ç¼ç åºçä½¿ç¨ä¸æ­£ç¡® æ²¡æå­ç¬¦éå¯éæ°ç¼ç å° %3d æ²¡æéè¯¯ æ²¡æå¯ä»¥æå°çè½¬æ¢è¡¨ æ²¡æä»â%sâéæ°ç¼ç è³â%sâçéå¾ ä¸æ­£è§çè¾å¥ ç¬¬ %d å·æ å°ï¼<%3dï¼%3d> ä¸ <%3dï¼%3d> å²çª éæ°ç¼ç  %s... éæ°ç¼ç å¤ªè¿å¤æï¼æ æ³ä»¥ä¸å¼ è½¬æ¢è¡¨è¡¨ç¤º è¯·æ±â%sâæéè¯¯ è¯·æ±ï¼%s
 ç¼ºå°éè¦çåæ° ä¸ºâ%sâæ½å äºå¤äºä¸ä¸ªçå¤å¨ç¼ç  åºåâ%sâæä¹ä¸æç¡® åºåâ%sâæªç¥ ç¼©åå°ï¼%s
 å¯¹ä¸èµ·ï¼â%sâæ²¡æå¯ç¨çå­ç¬¦å æ­¥éª¤åå§åå¤±è´¥ æ­¥éª¤åå§åå¤±è´¥(æªå¤ççéé¡¹) ç¬¦å·â%sâæªç¥ è¯­æ³å·²è¿æ¶ï¼è¯·æ¹ç¨â%sâ ç³»ç»é®é¢ æ¬ç¨åºæ¯èªç±è½¯ä»¶ï¼è¯·åçæºä»£ç ççæå£°æãæ¬è½¯ä»¶ä¸æä¾ä»»ä½æä¿ï¼
åæ¬æ²¡æééæ§åæä¸ä¸ç¨ç®çä¸çéç¨æ§æä¿ã
 æ­¤ç¨åºæ¯èªç±è½¯ä»¶ï¼æ¨å¯ä»¥å¨èªç±è½¯ä»¶åºéä¼åå¸ç GNU éç¨å¬å±è®¸
å¯è¯çæ¡æ¬¾ä¸éæ°ååå(æ)ä¿®æ¹å®ï¼æ¨å¯ä»¥éæ©ä½¿ç¨ GPL ç¬¬äºçï¼
æ(æç§æ¨çææ¿)ä»»ä½æ´æ°ççæ¬ã

è¯¥ç¨åºååçç®çæ¯ä¸ºäºå¶ä»äººå¯ä»¥ä½¿ç¨å®ï¼ä½æ¯æ²¡æä»»ä½æä¿ï¼ä¹æ²¡
æå¯¹å¶ééæ§åæä¸ç¹å®ç®çä¸çéç¨æ§çæä¿ãè¯·æ¥é GNU éç¨å¬
å±è®¸å¯è¯æ¥è·å¾æ´å¤çä¿¡æ¯ã

ä½ åºè¯¥å·²ç»è·æ¬ç¨åºä¸èµ·æ¶å°ä¸ä»½ GNU éç¨å¬å±è®¸å¯è¯ï¼å¦ææ²¡æï¼
è¯·åä¿¡è³ï¼Free Software Foundation, Inc., 
59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 è¯·å°è¯æ§è¡â%s %sâä»¥å¾å°æ´å¤ä¿¡æ¯ã
 UCS2   å©è®°     æè¿°

 å¦ææ²¡æè®¾ç½® DEFAULT_CHARSET ç¯å¢åéï¼å­ç¬¦éé»è®¤ä¸ºåºåéé¡¹çç¼ç ï¼ç± LC_ALLã
LC_CTYPEãLANG å³å®ã
 æ æ³è¯å«çå¤å¨ç¼ç â%sâ ä¸ºâ%sâå»é¤äºå¤äºä¸ä¸ªçå¤å¨ç¼ç  æ æ³ç¿»è¯çè¾å¥ èæåå­èå°½ èæåå­èå°½ï¼ ä½¿ç¨ -k æ¶ï¼ç®æ å­ç¬¦éå¯è½å¯¹åºçææçæºå­ç¬¦éé½å°ååºï¼ä¸¤èåä¸ºè¡¨æ ¼åçå­ç¬¦
éï¼âæ å°âå·æâæº1:ç®æ 1,æº2:ç®æ 2,...âçå½¢å¼ï¼å¶ä¸­âæºxâåâç®æ xâå
é¡»ä»¥åè¿å¶æ°çå½¢å¼ç»åºã
 ç± Francois Pinard <pinard@iro.umontreal.ca> ç¼åã
 å­è å¯éç ucs2 åé 