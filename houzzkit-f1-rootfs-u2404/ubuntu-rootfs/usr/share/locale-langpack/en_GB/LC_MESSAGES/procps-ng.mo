��          �   %   �      p  N   q     �  I   �  B   %  2   h  ;   �  4   �  +        8     W      t     �     �    �  ?  �     �       e  "     �     �     �  =   �  5   �     4     R  (   d     �  �  �  O   O     �  J   �  C     2   J  A   }  5   �  ,   �     "     A      ^          �    �  D  �#     �(     )  [  )     p/     �/     �/  <   �/  4   �/     0     70  (   I0     r0                  
                                                                                                     	    
        --%s <%s|%s|%s|%s|%s|%s>
                      display help and exit
 
For more details see %s.
   -C, --no-color         do not interpret ANSI color and style sequences
   -c, --color            interpret ANSI color and style sequences
  -D, --disk-sum         summarize disk statistics
  -O, --older <seconds>     select where older than seconds
  -V, --version  output version information and exit
  -h, --help     display this help and exit
  u: sort by cache utilization
 %13lld nice guest cpu ticks
 %13lld non-nice guest cpu ticks
 CPU Utilization Controlling Tty Help for Windows / Field Groups~2 - "Current Window" = ~1 %s ~6

. Use multiple ~1windows~2, each with separate config opts (color,fields,sort,etc)
. The 'current' window controls the ~1Summary Area~2 and responds to your ~1Commands~2
  . that window's ~1task display~2 can be turned ~1Off~2 & ~1On~2, growing/shrinking others
  . with ~1NO~2 task display, some commands will be ~1disabled~2 ('i','R','n','c', etc)
    until a ~1different window~2 has been activated, making it the 'current' window
. You ~1change~2 the 'current' window by: ~1 1~2) cycling forward/backward;~1 2~2) choosing
  a specific field group; or~1 3~2) exiting the color mapping or fields screens
. Commands ~1available anytime   -------------~2
    A       . Alternate display mode toggle, show ~1Single~2 / ~1Multiple~2 windows
    g       . Choose another field group and make it 'current', or change now
              by selecting a number from: ~1 1~2 =%s;~1 2~2 =%s;~1 3~2 =%s; or~1 4~2 =%s
. Commands ~1requiring~2 '~1A~2' mode~1  -------------~2
    G       . Change the ~1Name~5 of the 'current' window/field group
 ~1*~4  a , w   . Cycle through all four windows:  '~1a~5' Forward; '~1w~5' Backward
 ~1*~4  - , _   . Show/Hide:  '~1-~5' ~1Current~2 window; '~1_~5' all ~1Visible~2/~1Invisible~2
  The screen will be divided evenly between task displays.  But you can make
  some ~1larger~2 or ~1smaller~2, using '~1n~2' and '~1i~2' commands.  Then later you could:
 ~1*~4  = , +   . Rebalance tasks:  '~1=~5' ~1Current~2 window; '~1+~5' ~1Every~2 window
              (this also forces the ~1current~2 or ~1every~2 window to become visible)

In '~1A~2' mode, '~1*~4' keys are your ~1essential~2 commands.  Please try the '~1a~2' and '~1w~2'
commands plus the 'g' sub-commands NOW.  Press <Enter> to make 'Current'  Help for color mapping~2 - "Current Window" = ~1 %s ~6

   color - 04:25:44 up 8 days, 50 min,  7 users,  load average:
   Tasks:~3  64 ~2total,~3   2 ~3running,~3  62 ~2sleeping,~3   0 ~2stopped,~3
   %%Cpu(s):~3  76.5 ~2user,~3  11.2 ~2system,~3   0.0 ~2nice,~3  12.3 ~2idle~3
   ~1 Nasty Message! ~4  -or-  ~1Input Prompt~5
   ~1  PID TTY     PR  NI %%CPU    TIME+   VIRT SWAP S COMMAND    ~6
   17284 ~8pts/2  ~7  8   0  0.0   0:00.75  1380    0 S /bin/bash   ~8
   ~1 8601 pts/1    7 -10  0.4   0:00.03   916    0 R color -b -z~7
   11005 ~8?      ~7  9   0  0.0   0:02.50  2852 1008 S amor -sessi~8
   available toggles: ~1B~2 =disable bold globally (~1%s~2),
       ~1z~2 =color/mono (~1%s~2), ~1b~2 =tasks "bold"/reverse (~1%s~2)

1) Select a ~1target~2 as an upper case letter, ~1current target~2 is ~1 %c ~4:
   S~2 = Summary Data,~1  M~2 = Messages/Prompts,
   H~2 = Column Heads,~1  T~2 = Task Information
2) Select a ~1color~2 as a number or use the up/down arrow keys
   to raise/lower the %d colors value, ~1current color~2 is ~1 %d ~4:
   0~2 = black,~1  1~2 = red,    ~1  2~2 = green,~1  3~2 = yellow,
   4~2 = blue, ~1  5~2 = magenta,~1  6~2 = cyan, ~1  7~2 = white

3) Then use these keys when finished:
   'q' or <Esc> to abort changes to window '~1%s~2'
   'a' or 'w' to commit & change another, <Enter> to commit and end  Last Used Cpu (SMP) No colors to map! This is simulated output representing the contents of some file or the output
from some command.  Exactly which commands and/or files are solely up to you.

Although this text is for information purposes only, it can still be scrolled
and searched like real output will be.  You are encouraged to experiment with
those features as explained in the prologue above.

To enable real Inspect functionality, entries must be added to the end of the
top personal personal configuration file.  You could use your favorite editor
to accomplish this, taking care not to disturb existing entries.

Another way to add entries is illustrated below, but it risks overwriting the
rcfile.  Redirected echoes must not replace (>) but append (>>) to that file.

  /bin/echo -e "pipe\tOpen Files\tlsof -P -p %d 2>&1" >> ~/.toprc
  /bin/echo -e "file\tNUMA Info\t/proc/%d/numa_maps" >> ~/.toprc
  /bin/echo -e "pipe\tLog\ttail -n200 /var/log/syslog | sort -Mr" >> ~/.toprc

If you don't know the location or name of the top rcfile, use the 'W' command
and note those details.  After backing up the current rcfile, try issuing the
above echoes exactly as shown, replacing '.toprc' as appropriate.  The safest
approach would be to use copy then paste to avoid any typing mistakes.

Finally, restart top to reveal what actual Inspect entries combined with this
new command can offer.  The possibilities are endless, especially considering
that 'pipe' type entries can include shell scripts too!

For additional important information, please consult the top(1) man document.
Then, enhance top with your very own customized 'file' and/or 'pipe' entries.

Enjoy!
 Tty Process Grp Id Utilization + child can not open tty can not set width for a macro (multi-column) format specifier can not use output modifiers with user-defined output expand which numa node (0-%d) invalid numa node library failed cpu statistics, at %d: %s unrecognized field name '%s' Project-Id-Version: procps
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2024-04-14 18:43+0000
Last-Translator: Andi Chandler <Unknown>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:12+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
        --%s <%s|%s|%s|%s|%s|%s>
                      display help, and exit
 
For more details, see %s.
   -C, --no-color         do not interpret ANSI colour and style sequences
   -c, --color            interpret ANSI colour and style sequences
  -D, --disk-sum         summarise disk statistics
  -O, --older <seconds>     select where older than these seconds
  -V, --version  output version information, and exit
  -h, --help     display this help, and exit
  u: sort by cache utilisation
 %13lld nice guest CPU ticks
 %13lld non-nice guest CPU ticks
 CPU Utilisation Controlling TTY Help for Windows / Field Groups~2 - "Current Window" = ~1 %s ~6

. Use multiple ~1windows~2, each with separate config opts (colour,fields,sort,etc)
. The 'current' window controls the ~1Summary Area~2 and responds to your ~1Commands~2
  . that window's ~1task display~2 can be turned ~1Off~2 & ~1On~2, growing/shrinking others
  . with ~1NO~2 task display, some commands will be ~1disabled~2 ('i','R','n','c', etc)
    until a ~1different window~2 has been activated, making it the 'current' window
. You ~1change~2 the 'current' window by: ~1 1~2) cycling forward/backward;~1 2~2) choosing
  a specific field group; or~1 3~2) exiting the colour mapping or fields screens
. Commands ~1available anytime   -------------~2
    A       . Alternate display mode toggle, show ~1Single~2 / ~1Multiple~2 windows
    g       . Choose another field group and make it 'current', or change now
              by selecting a number from: ~1 1~2 =%s;~1 2~2 =%s;~1 3~2 =%s; or~1 4~2 =%s
. Commands ~1requiring~2 '~1A~2' mode~1  -------------~2
    G       . Change the ~1Name~5 of the 'current' window/field group
 ~1*~4  a , w   . Cycle through all four windows:  '~1a~5' Forward; '~1w~5' Backward
 ~1*~4  - , _   . Show/Hide:  '~1-~5' ~1Current~2 window; '~1_~5' all ~1Visible~2/~1Invisible~2
  The screen will be divided evenly between task displays.  But you can make
  some ~1larger~2 or ~1smaller~2, using '~1n~2' and '~1i~2' commands.  Then later you could:
 ~1*~4  = , +   . Rebalance tasks:  '~1=~5' ~1Current~2 window; '~1+~5' ~1Every~2 window
              (this also forces the ~1current~2 or ~1every~2 window to become visible)

In '~1A~2' mode, '~1*~4' keys are your ~1essential~2 commands.  Please try the '~1a~2' and '~1w~2'
commands plus the 'g' sub-commands NOW.  Press <Enter> to make 'Current'  Help for colour mapping~2 - "Current Window" = ~1 %s ~6

   colour - 04:25:44 up 8 days, 50 min,  7 users,  load average:
   Tasks:~3  64 ~2total,~3   2 ~3running,~3  62 ~2sleeping,~3   0 ~2stopped,~3
   %%Cpu(s):~3  76.5 ~2user,~3  11.2 ~2system,~3   0.0 ~2nice,~3  12.3 ~2idle~3
   ~1 Nasty Message! ~4  -or-  ~1Input Prompt~5
   ~1  PID TTY     PR  NI %%CPU    TIME+   VIRT SWAP S COMMAND    ~6
   17284 ~8pts/2  ~7  8   0  0.0   0:00.75  1380    0 S /bin/bash   ~8
   ~1 8601 pts/1    7 -10  0.4   0:00.03   916    0 R color -b -z~7
   11005 ~8?      ~7  9   0  0.0   0:02.50  2852 1008 S amor -sessi~8
   available toggles: ~1B~2 =disable bold globally (~1%s~2),
       ~1z~2 =colour/mono (~1%s~2), ~1b~2 =tasks "bold"/reverse (~1%s~2)

1) Select a ~1target~2 as an upper case letter, ~1current target~2 is ~1 %c ~4:
   S~2 = Summary Data,~1  M~2 = Messages/Prompts,
   H~2 = Column Heads,~1  T~2 = Task Information
2) Select a ~1colour~2 as a number or use the up/down arrow keys
   to raise/lower the %d colour value, ~1current colour~2 is ~1 %d ~4:
   0~2 = black,~1  1~2 = red,    ~1  2~2 = green,~1  3~2 = yellow,
   4~2 = blue, ~1  5~2 = magenta,~1  6~2 = cyan, ~1  7~2 = white

3) Then use these keys when finished:
   'q' or <Esc> to abort changes to window '~1%s~2'
   'a' or 'w' to commit & change another, <Enter> to commit and end  Last Used CPU (SMP) No colours to map! This is simulated output representing the contents of some file or the output
from some command.  Exactly which commands and/or files are solely up to you.

Although this text is for information purposes only, it can still be scrolled
and searched as real output will be.  You are encouraged to experiment with
those features as explained in the prologue above.

To enable real Inspect functionality, entries must be added to the end of the
top personal configuration file.  You could use your favourite editor
to accomplish this, taking care not to disturb existing entries.

Another way to add entries is illustrated below, but it risks overwriting the
rcfile.  Redirected echoes must not replace (>) but append (>>) to that file.

  /bin/echo -e "pipe\tOpen Files\tlsof -P -p %d 2>&1" >> ~/.toprc
  /bin/echo -e "file\tNUMA Info\t/proc/%d/numa_maps" >> ~/.toprc
  /bin/echo -e "pipe\tLog\ttail -n200 /var/log/syslog | sort -Mr" >> ~/.toprc

If you don't know the location or name of the top rcfile, use the 'W' command
and note those details.  After backing up the current rcfile, try issuing the
above echoes exactly as shown, replacing '.toprc' as appropriate.  The safest
approach would be to use copy-then-paste to avoid any typing mistakes.

Finally, restart top to reveal what actual Inspect entries combined with this
new command can offer.  The possibilities are endless, especially considering
that 'pipe' type entries can include shell scripts too!

For additional important information, please consult the top(1) man document.
Then, enhance top with your very own customized 'file' and/or 'pipe' entries.

Enjoy!
 TTY Process Grp Id Utilisation + child cannot open tty cannot set width for a macro (multi-column) format specifier cannot use output modifiers with user-defined output expand which NUMA node (0-%d) invalid NUMA node library failed CPU statistics, at %d: %s unrecognised field name '%s' 