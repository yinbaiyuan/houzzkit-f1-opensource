��    y      �  �   �      8
  �   9
  �   2  �   �  G  �  �   �  �   �  p   �  !    �   0  w  �  5  e  ~   �  G     w   b    �  �   �  b  z  �   �  �   f  �   /    �  >   �  �     �   �    T  �   f  �  #  �   �   �   �!  �   ."  �   �"  i   �#  Z   7$  �   �$  �   1%  �  �%    v'  �   �(  �   b)  �   �)  �   �*    r+  �   �,  �   -  4  �-    �.    �/  �  �0  �   �2  �  �3  �   D5  1   C6  �   u6  �   T7  �   �7  �   �8  �   x9    d:  �   s;  C   G<  �  �<  $   &>  $   K>  *   p>  9   �>  #   �>  !   �>  �   ?  ,   �?  "   &@  ;   I@  	   �@     �@     �@  �   �@  \   oA  o   �A  i  <B  �   �C     -D     >D  ,   SD  &   �D      �D  '   �D  0   �D  Y   !E  T   {E  (   �E  T   �E  g   NF  �   �F  Y   =G  ~   �G  �   H  �   �H  F   ^I  Z   �I  `    J      aJ  '   �J  <   �J  T   �J  �  <K  ;   �L  3   -M  /   aM  +   �M  '   �M  #   �M     	N     )N  0   EN  *   vN     �N  ]   �N  "   O     <O     TO  7   lO  �  �O  �   �Q  �   ZR  �   S    �S  �   �T  �   vU  d   V     �V  �   �W  k  <X    �Y  r   �Z  F   1[  u   x[  	  �[  �   �\  c  �]  �   �^  �   w_  ~   5`    �`  >   �a  �   b  �   �b    Oc  �   Sd  �  e  �   �f  �   :g  �   �g  �   bh  a   -i  R   �i  �   �i  �   yj  j  k    wl  �   �m  �   Cn  �   �n  �   ko  �   'p  �   'q  k   �q     r    s  �   t  �  u  �   �v  �  �w  �   My  +   z  �   Jz  u   {  �   �{  �   /|  �   �|  �   �}  �   �~  A   t  j  �  !   !�  !   C�  &   e�  6   ��  "   Á      �  �   �  '   ׂ     ��  6   �     T�     ]�     i�  �   ~�  P   -�  n   ~�  D  �  �   2�     ��     Ɇ  +   ߆  %   �     1�  &   Q�  /   x�  W   ��  S    �  '   T�  S   |�  e   Ј  �   6�  X   ��  |   �  �   ��  �   3�  E   ԋ  W   �  _   r�  !   Ҍ  &   �  ;   �  P   W�  �  ��  :   ^�  2   ��  .   ̏  *   ��  &   &�  "   M�     p�     ��  1   ��  *   ܐ     �  ]   !�  #   �     ��     ��  7   ӑ        F   a               h                  r   X          K   g   %          ^   A       c                         S      I   n   ?            V          J   7             E           4   e          f   o   $   (   2   P          s   x   *       p   <      m   &   v   T   :   k   1       /               	   w      q   u       8      y   W      `      t   9   0   _           B                  Q   C       Y   G   
           ,      D   O   +   Z   l   N   M   ]       !   j       "   3       -              \   =   ;   i   L      .   b      [   R   >   5   U   )   d       H      6       '   @               #          
  ( EXPRESSION )               EXPRESSION is true
  ! EXPRESSION                 EXPRESSION is false
  EXPRESSION1 -a EXPRESSION2   both EXPRESSION1 and EXPRESSION2 are true
  EXPRESSION1 -o EXPRESSION2   either EXPRESSION1 or EXPRESSION2 is true
 
  -a, --all         same as -b -d --login -p -r -t -T -u
  -b, --boot        time of last system boot
  -d, --dead        print dead processes
  -H, --heading     print line of column headings
 
  -b FILE     FILE exists and is block special
  -c FILE     FILE exists and is character special
  -d FILE     FILE exists and is a directory
  -e FILE     FILE exists
 
  -l              produce long format output for the specified USERs
  -b              omit the user's home directory and shell in long format
  -h              omit the user's project file in long format
  -p              omit the user's plan file in long format
  -s              do short format output, this is the default
 
  -n STRING            the length of STRING is nonzero
  STRING               equivalent to -n STRING
  -z STRING            the length of STRING is zero
  STRING1 = STRING2    the strings are equal
  STRING1 != STRING2   the strings are not equal
 
  ARG1 * ARG2       arithmetic product of ARG1 and ARG2
  ARG1 / ARG2       arithmetic quotient of ARG1 divided by ARG2
  ARG1 % ARG2       arithmetic remainder of ARG1 divided by ARG2
 
  ARG1 + ARG2       arithmetic sum of ARG1 and ARG2
  ARG1 - ARG2       arithmetic difference of ARG1 and ARG2
 
  ARG1 < ARG2       ARG1 is less than ARG2
  ARG1 <= ARG2      ARG1 is less than or equal to ARG2
  ARG1 = ARG2       ARG1 is equal to ARG2
  ARG1 != ARG2      ARG1 is unequal to ARG2
  ARG1 >= ARG2      ARG1 is greater than or equal to ARG2
  ARG1 > ARG2       ARG1 is greater than ARG2
 
  FILE1 -ef FILE2   FILE1 and FILE2 have the same device and inode numbers
  FILE1 -nt FILE2   FILE1 is newer (modification date) than FILE2
  FILE1 -ot FILE2   FILE1 is older than FILE2
 
  INTEGER1 -eq INTEGER2   INTEGER1 is equal to INTEGER2
  INTEGER1 -ge INTEGER2   INTEGER1 is greater than or equal to INTEGER2
  INTEGER1 -gt INTEGER2   INTEGER1 is greater than INTEGER2
  INTEGER1 -le INTEGER2   INTEGER1 is less than or equal to INTEGER2
  INTEGER1 -lt INTEGER2   INTEGER1 is less than INTEGER2
  INTEGER1 -ne INTEGER2   INTEGER1 is not equal to INTEGER2
 
  STRING : REGEXP   anchored pattern match of REGEXP in STRING

  match STRING REGEXP        same as STRING : REGEXP
  substr STRING POS LENGTH   substring of STRING, POS counted from 1
  index STRING CHARS         index in STRING where any CHARS is found, or 0
  length STRING              length of STRING
 
  b      create a block (buffered) special file
  c, u   create a character (unbuffered) special file
  p      create a FIFO
 
A mere - implies -i.  If no COMMAND, print the resulting environment.
 
An omitted EXPRESSION defaults to false.  Otherwise,
EXPRESSION is true or false and sets exit status.  It is one of:
 
Both MAJOR and MINOR must be specified when TYPE is b, c, or u, and they
must be omitted when TYPE is p.  If MAJOR or MINOR begins with 0x or 0X,
it is interpreted as hexadecimal; otherwise, if it begins with 0, as octal;
otherwise, as decimal.  TYPE may be:
 
By default, rm does not remove directories.  Use the --recursive (-r or -R)
option to remove each listed directory, too, along with all of its contents.
 
By default, sparse SOURCE files are detected by a crude heuristic and the
corresponding DEST file is made sparse as well.  That is the behavior
selected by --sparse=auto.  Specify --sparse=always to create a sparse DEST
file whenever the SOURCE file contains a long enough sequence of zero bytes.
Use --sparse=never to inhibit creation of sparse files.
 
Examples:
  %s f - g  Output f's contents, then standard input, then g's contents.
  %s        Copy standard input to standard output.
 
Examples:
  %s root /u        Change the owner of /u to "root".
  %s root:staff /u  Likewise, but also change its group to "staff".
  %s -hR root /u    Change the owner of /u and subfiles to "root".
 
Examples:
  %s staff /u      Change the group of /u to "staff".
  %s -hR staff /u  Change the group of /u and subfiles to "staff".
 
Handle the tty line connected to standard input.  Without arguments,
prints baud rate, line discipline, and deviations from stty sane.  In
settings, CHAR is taken literally, or coded as in ^c, 0x37, 0177 or
127; special values ^- or undef used to disable special characters.
 
If -e is in effect, the following sequences are recognized:

 
NOTE: your shell may have its own version of %s, which usually supersedes
the version described here.  Please refer to your shell's documentation
for details about the options it supports.
 
Optional - before SETTING indicates negation.  An * marks non-POSIX
settings.  The underlying system defines which settings are available.
 
Print the value of EXPRESSION to standard output.  A blank line below
separates increasing precedence groups.  EXPRESSION may be:

  ARG1 | ARG2       ARG1 if it is neither null nor 0, otherwise ARG2

  ARG1 & ARG2       ARG1 if neither argument is null or 0, otherwise 0
 
With no options, produce three-column output.  Column one contains
lines unique to FILE1, column two contains lines unique to FILE2,
and column three contains lines common to both files.
       --backup[=CONTROL]      make a backup of each existing destination file
  -b                          like --backup but does not accept an argument
  -d, -F, --directory         allow the superuser to attempt to hard link
                                directories (note: will probably fail due to
                                system restrictions, even for the superuser)
  -f, --force                 remove existing destination files
       --lookup      attempt to canonicalize hostnames via DNS
  -m                only hostname and user associated with stdin
  -p, --process     print active processes spawned by init
       --no-preserve=ATTR_LIST  don't preserve the specified attributes
      --parents                use full source file name under DIRECTORY
    oddp          same as parenb parodd cs7
   -oddp         same as -parenb cs8
   [-]parity     same as [-]evenp
   pass8         same as -parenb -istrip cs8
   -pass8        same as parenb istrip cs7
   %A   locale's full weekday name (e.g., Sunday)
  %b   locale's abbreviated month name (e.g., Jan)
  %B   locale's full month name (e.g., January)
  %c   locale's date and time (e.g., Thu Mar  3 23:05:25 2005)
   %S   second (00..60)
  %t   a tab
  %T   time; same as %H:%M:%S
  %u   day of week (1..7); 1 is Monday
   %h   same as %b
  %H   hour (00..23)
  %I   hour (01..12)
  %j   day of year (001..366)
   %x   locale's date representation (e.g., 12/31/99)
  %X   locale's time representation (e.g., 23:13:48)
  %y   last two digits of year (00..99)
  %Y   year
   -T, -w, --mesg    add user's message status as +, - or ?
  -u, --users       list users logged in
      --message     same as -T
      --writable    same as -T
   -W, --word-regexp=REGEXP       use REGEXP to match each keyword
  -b, --break-file=FILE          word break characters in this FILE
  -f, --ignore-case              fold lower case to upper case for sorting
  -g, --gap-size=NUMBER          gap size in columns between output fields
  -i, --ignore-file=FILE         read ignore word list from FILE
  -o, --only-file=FILE           read only word list from this FILE
   -a, --across      print columns across rather than down, used together
                    with -COLUMN
  -c, --show-control-chars
                    use hat notation (^G) and octal backslash notation
  -d, --double-space
                    double space the output
   -b, --before             attach the separator before instead of after
  -r, --regex              interpret the separator as a regular expression
  -s, --separator=STRING   use STRING as the separator instead of newline
   -b, --bytes         count bytes rather than columns
  -s, --spaces        break at spaces
  -w, --width=WIDTH   use WIDTH columns instead of 80
   -b, --bytes=LIST        select only these bytes
  -c, --characters=LIST   select only these characters
  -d, --delimiter=DELIM   use DELIM instead of TAB for field delimiter
   -b, --ignore-leading-blanks  ignore leading blanks
  -d, --dictionary-order      consider only blanks and alphanumeric characters
  -f, --ignore-case           fold lower case to upper case characters
   -c, --crown-margin        preserve indentation of first two lines
  -p, --prefix=STRING       reformat only lines beginning with STRING,
                              reattaching the prefix to reformatted lines
  -s, --split-only          split long lines, but do not refill
   -d, --delimiters=LIST   reuse characters from LIST instead of TABs
  -s, --serial            paste one file at a time instead of in parallel
   -e             enable interpretation of backslash escapes (default)
  -E             disable interpretation of backslash escapes
   -f              omit the line of column headings in short format
  -w              omit the user's full name in short format
  -i              omit the user's full name and remote host in short format
  -q              omit the user's full name, remote host and idle time
                  in short format
   -f   same as -t fF, select floats
  -i   same as -t dI, select decimal ints
  -l   same as -t dL, select decimal longs
  -o   same as -t o2, select octal 2-byte units
  -s   same as -t d2, select decimal 2-byte units
  -x   same as -t x2, select hexadecimal 2-byte units
   -f FILE     FILE exists and is a regular file
  -g FILE     FILE exists and is set-group-ID
  -G FILE     FILE exists and is owned by the effective group ID
  -h FILE     FILE exists and is a symbolic link (same as -L)
  -k FILE     FILE exists and has its sticky bit set
   -f, --canonicalize            canonicalize by following every symlink in
                                every component of the given name recursively;
                                all but the last component must exist
  -e, --canonicalize-existing   canonicalize by following every symlink in
                                every component of the given name recursively,
                                all components must exist
   -f, --fields=LIST       select only these fields;  also print any line
                            that contains no delimiter character, unless
                            the -s option is specified
  -n                      (ignored)
   -h, --header=HEADER
                    use a centered HEADER instead of filename in page header,
                    -h "" prints a blank line, don't use -h""
  -i[CHAR[WIDTH]], --output-tabs[=CHAR[WIDTH]]
                    replace spaces with CHARs (TABs) to tab WIDTH (8)
  -J, --join-lines  merge full lines, turns off -W line truncation, no column
                    alignment, --sep-string[=STRING] sets separators
   -i, --inodes          list inode information instead of block usage
  -k                    like --block-size=1K
  -l, --local           limit listing to local file systems
      --no-sync         do not invoke sync before getting usage info (default)
   -l, --login       print system login processes
   -q, --count       all login names and number of users logged on
  -r, --runlevel    print current runlevel
  -s, --short       print only name, line, and time (default)
  -t, --time        print last system clock change
   -q, --quiet, --silent    never print headers giving file names
  -v, --verbose            always print headers giving file names
   -r, --references               first field of each line is a reference
  -t, --typeset-mode               - not implemented -
  -w, --width=NUMBER             output width in columns, reference excluded
   -s, --only-delimited    do not print lines not containing delimiters
      --output-delimiter=STRING  use STRING as the output delimiter
                            the default is to use the input delimiter
   -s, --signal=SIGNAL, -SIGNAL
                   specify the name or number of the signal to be sent
  -l, --list       list signal names, or convert signal names to/from numbers
  -t, --table      print a table of signal information
   -s, --symbolic-link          make symbolic links instead of copying
  -S, --suffix=SUFFIX          override the usual backup suffix
  -t, --target-directory=DIRECTORY  copy all SOURCE arguments into DIRECTORY
  -T, --no-target-directory    treat DEST as a normal file
   -t                       equivalent to -vT
  -T, --show-tabs          display TAB characters as ^I
  -u                       (ignored)
  -v, --show-nonprinting   use ^ and M- notation, except for LFD and TAB
   -w, --check-chars=N   compare no more than N characters in lines
   [:graph:]       all printable characters, not including space
  [:lower:]       all lower case letters
  [:print:]       all printable characters, including space
  [:punct:]       all punctuation characters
  [:space:]       all horizontal or vertical whitespace
  [:upper:]       all upper case letters
  [:xdigit:]      all hexadecimal digits
  [=CHAR=]        all characters which are equivalent to CHAR
   binary    use binary I/O for data
   direct    use direct I/O for data
   dsync     use synchronized I/O for data
   noctty    do not assign controlling terminal from file
   nofollow  do not follow symlinks
   nonblock  use non-blocking I/O
   none, off       never make backups (even if --backup is given)
  numbered, t     make numbered backups
  existing, nil   numbered if numbered backups exist, simple otherwise
  simple, never   always make simple backups
   sync      likewise, but also for metadata
   text      use text I/O for data
  * [-]iutf8      assume input characters are UTF-8 encoded
 %b %e  %Y %b %e %H:%M ,  load average: %.2f Copy standard input to each FILE, and also to standard output.

  -a, --append              append to the given FILEs, do not overwrite
  -i, --ignore-interrupts   ignore interrupt signals
 Echo the STRING(s) to standard output.

  -n             do not output the trailing newline
 Output who is currently logged in according to FILE.
If FILE is not specified, use %s.  %s as FILE is common.

 Print certain system information.  With no OPTION, same as -s.

  -a, --all                print all information, in the following order,
                             except omit -p and -i if unknown:
  -s, --kernel-name        print the kernel name
  -n, --nodename           print the network node hostname
  -r, --kernel-release     print the kernel release
 Print the file name of the terminal connected to standard input.

  -s, --silent, --quiet   print nothing, only return an exit status
 Request canceled Request not canceled Usage: %s COMMAND [ARG]...
  or:  %s OPTION
 Usage: %s EXPRESSION
  or:  %s OPTION
 Usage: %s FILE
  or:  %s OPTION
 Usage: %s FILE1 FILE2
  or:  %s OPTION
 Usage: %s FORMAT [ARGUMENT]...
  or:  %s OPTION
 Usage: %s [-s SIGNAL | -SIGNAL] PID...
  or:  %s -l [SIGNAL]...
  or:  %s -t [SIGNAL]...
 Usage: %s [NAME]
  or:  %s OPTION
Print or set the hostname of the current system.

 Usage: %s [OPERAND]...
  or:  %s OPTION
 Usage: %s [OPTION]... GROUP FILE...
  or:  %s [OPTION]... --reference=RFILE FILE...
 Usage: %s [OPTION]... LAST
  or:  %s [OPTION]... FIRST LAST
  or:  %s [OPTION]... FIRST INCREMENT LAST
 Usage: %s [OPTION]... MODE[,MODE]... FILE...
  or:  %s [OPTION]... OCTAL-MODE FILE...
  or:  %s [OPTION]... --reference=RFILE FILE...
 Usage: %s [OPTION]... [+FORMAT]
  or:  %s [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
 Usage: %s [OPTION]... [-T] SOURCE DEST
  or:  %s [OPTION]... SOURCE... DIRECTORY
  or:  %s [OPTION]... -t DIRECTORY SOURCE...
 Usage: %s [OPTION]... [-T] SOURCE DEST
  or:  %s [OPTION]... SOURCE... DIRECTORY
  or:  %s [OPTION]... -t DIRECTORY SOURCE...
  or:  %s [OPTION]... -d DIRECTORY...
 Usage: %s [OPTION]... [FILE]...
  or:  %s [-abcdfilosx]... [FILE] [[+]OFFSET[.][b]]
  or:  %s --traditional [OPTION]... [FILE] [[+]OFFSET[.][b] [+][LABEL][.][b]]
 Usage: %s [OPTION]... [FILE]...
  or:  %s [OPTION]... --files0-from=F
 Usage: %s [OPTION]... [INPUT]...   (without -G)
  or:  %s -G [OPTION]... [INPUT [OUTPUT]]
 Usage: %s [OPTION]... [OWNER][:[GROUP]] FILE...
  or:  %s [OPTION]... --reference=RFILE FILE...
 Usage: %s [OPTION]... [USER]...
 Usage: %s [STRING]...
  or:  %s OPTION
 Usage: %s [ignored command line arguments]
  or:  %s OPTION
 Usage: test EXPRESSION
  or:  test
  or:  [ EXPRESSION ]
  or:  [ ]
  or:  [ OPTION
 With --follow (-f), tail defaults to following the file descriptor, which
means that even if a tail'ed file is renamed, tail will continue to track
its end.  This default behavior is not desirable when you really want to
track the actual name of the file, not the file descriptor (e.g., log
rotation).  Use --follow=name in that case.  That causes tail to track the
named file in a way that accommodates renaming, removal and creation.
 Written by %s, %s, %s,
%s, %s, %s, %s,
%s, %s, and others.
 Written by %s, %s, %s,
%s, %s, %s, %s,
%s, and %s.
 Written by %s, %s, %s,
%s, %s, %s, %s,
and %s.
 Written by %s, %s, %s,
%s, %s, %s, and %s.
 Written by %s, %s, %s,
%s, %s, and %s.
 Written by %s, %s, %s,
%s, and %s.
 Written by %s, %s, %s,
and %s.
 Written by %s, %s, and %s.
 can't apply partial context to unlabeled file %s cannot both summarize and show all entries failed to canonicalize %s invalid option -- %c; -WIDTH is recognized only when it is the first
option; use -w N instead number in parallel must be nonzero unrecognized operand %s unrecognized prefix: %s warning: summarizing is the same as using --max-depth=0 Project-Id-Version: coreutils
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2020-11-28 04:39+0000
Last-Translator: Jared Norris <jarednorris@ubuntu.com>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Launchpad-Export-Date: 2025-01-30 16:37+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
  ( EXPRESSION ) EXPRESSION is true
  ! EXPRESSION EXPRESSION is false
  EXPRESSION1 -a EXPRESSION2 both EXPRESSION1 and EXPRESSION2 are true
  EXPRESSION1 -o EXPRESSION2 either EXPRESSION1 or EXPRESSION2 is true
 
  -a, --all same as -b -d --login -p -r -t -T -u
  -b, --boot time of last system boot
  -d, --dead print dead processes
  -H, --heading print line of column headings
 
  -b FILE FILE exists and is block special
  -c FILE FILE exists and is character special
  -d FILE FILE exists and is a directory
  -e FILE FILE exists
 
  -l produce long format output for the specified USERs
  -b omit the user's home directory and shell in long format
  -h omit the user's project file in long format
  -p omit the user's plan file in long format
  -s do short format output, this is the default
 
  -n STRING the length of STRING is nonzero
  STRING equivalent to -n STRING
  -z STRING the length of STRING is zero
  STRING1 = STRING2 the strings are equal
  STRING1 != STRING2 the strings are not equal
 
  ARG1 * ARG2 arithmetic product of ARG1 and ARG2
  ARG1 / ARG2 arithmetic quotient of ARG1 divided by ARG2
  ARG1 % ARG2 arithmetic remainder of ARG1 divided by ARG2
 
  ARG1 + ARG2 arithmetic sum of ARG1 and ARG2
  ARG1 - ARG2 arithmetic difference of ARG1 and ARG2
 
  ARG1 < ARG2 ARG1 is less than ARG2
  ARG1 <= ARG2 ARG1 is less than or equal to ARG2
  ARG1 = ARG2 ARG1 is equal to ARG2
  ARG1 != ARG2 ARG1 is unequal to ARG2
  ARG1 >= ARG2 ARG1 is greater than or equal to ARG2
  ARG1 > ARG2 ARG1 is greater than ARG2
 
  FILE1 -ef FILE2 FILE1 and FILE2 have the same device and inode numbers
  FILE1 -nt FILE2 FILE1 is newer (modification date) than FILE2
  FILE1 -ot FILE2 FILE1 is older than FILE2
 
  INTEGER1 -eq INTEGER2 INTEGER1 is equal to INTEGER2
  INTEGER1 -ge INTEGER2 INTEGER1 is greater than or equal to INTEGER2
  INTEGER1 -gt INTEGER2 INTEGER1 is greater than INTEGER2
  INTEGER1 -le INTEGER2 INTEGER1 is less than or equal to INTEGER2
  INTEGER1 -lt INTEGER2 INTEGER1 is less than INTEGER2
  INTEGER1 -ne INTEGER2 INTEGER1 is not equal to INTEGER2
 
  STRING : REGEXP anchored pattern match of REGEXP in STRING

  match STRING REGEXP same as STRING : REGEXP
  substr STRING POS LENGTH substring of STRING, POS counted from 1
  index STRING CHARS index in STRING where any CHARS is found, or 0
  length STRING length of STRING
 
  b create a block (buffered) special file
  c, u create a character (unbuffered) special file
  p create a FIFO
 
A mere - implies -i. If no COMMAND, print the resulting environment.
 
An omitted EXPRESSION defaults to false. Otherwise,
EXPRESSION is true or false and sets exit status. It is one of:
 
Both MAJOR and MINOR must be specified when TYPE is b, c, or u, and they
must be omitted when TYPE is p. If MAJOR or MINOR begins with 0x or 0X,
it is interpreted as hexadecimal; if it begins with 0, as octal;
otherwise, it is interpreted as decimal. TYPE may be:
 
By default, rm does not remove directories. Use the --recursive (-r or -R)
option to remove each listed directory, too, along with all of its contents.
 
By default, sparse SOURCE files are detected by a crude heuristic and the
corresponding DEST file is made sparse as well.  That is the behaviour
selected by --sparse=auto.  Specify --sparse=always to create a sparse DEST
file whenever the SOURCE file contains a long enough sequence of zero bytes.
Use --sparse=never to inhibit creation of sparse files.
 
Examples:
  %s f - g Output f's contents, then standard input, then g's contents.
  %s Copy standard input to standard output.
 
Examples:
  %s root /u Change the owner of /u to "root".
  %s root:staff /u Likewise, but also change its group to "staff".
  %s -hR root /u Change the owner of /u and subfiles to "root".
 
Examples:
  %s staff /u Change the group of /u to "staff".
  %s -hR staff /u Change the group of /u and subfiles to "staff".
 
Handle the tty line connected to standard input. Without arguments,
prints baud rate, line discipline, and deviations from stty sane. In
settings, CHAR is taken literally, or coded as in ^c, 0x37, 0177 or
127; special values ^- or undef used to disable special characters.
 
If -e is in effect, the following sequences are recognised:

 
NOTE: your shell may have its own version of %s, which usually supersedes
the version described here. Please refer to your shell's documentation
for details about the options it supports.
 
Optional - before SETTING indicates negation. An * marks non-POSIX
settings. The underlying system defines which settings are available.
 
Print the value of EXPRESSION to standard output. A blank line below
separates increasing precedence groups. EXPRESSION may be:

  ARG1 | ARG2 ARG1 if it is neither null nor 0, otherwise ARG2

  ARG1 & ARG2 ARG1 if neither argument is null or 0, otherwise 0
 
With no options, produce three-column output. Column one contains
lines unique to FILE1, column two contains lines unique to FILE2
and column three contains lines common to both files.
       --backup[=CONTROL] make a backup of each existing destination file
  -b like --backup but does not accept an argument
  -d, -F, --directory allow the superuser to attempt to hard link
                                directories (note: will probably fail due to
                                system restrictions, even for the superuser)
  -f, --force remove existing destination files
       --lookup attempt to canonicalize hostnames via DNS
  -m only hostname and user associated with stdin
  -p, --process print active processes spawned by init
       --no-preserve=ATTR_LIST don't preserve the specified attributes
      --parents use full source file name under DIRECTORY
    oddp same as parenb parodd cs7
   -oddp same as -parenb cs8
   [-]parity same as [-]evenp
   pass8 same as -parenb -istrip cs8
   -pass8 same as parenb istrip cs7
   %A locale's full weekday name (e.g., Sunday)
  %b locale's abbreviated month name (e.g., Jan)
  %B locale's full month name (e.g., January)
  %c locale's date and time (e.g., Thu Mar 3 23:05:25 2005)
   %S second (00..60)
  %t a tab
  %T time; same as %H:%M:%S
  %u day of week (1..7); 1 is Monday
   %h same as %b
  %H hour (00..23)
  %I hour (01..12)
  %j day of year (001..366)
   %x locale's date representation (e.g., 12/31/99)
  %X locale's time representation (e.g., 23:13:48)
  %y last two digits of year (00..99)
  %Y year
   -T, -w, --mesg add user's message status as +, - or ?
  -u, --users list users logged in
      --message same as -T
      --writable same as -T
   -W, --word-regexp=REGEXP use REGEXP to match each keyword
  -b, --break-file=FILE word break characters in this FILE
  -f, --ignore-case fold lower case to upper case for sorting
  -g, --gap-size=NUMBER gap size in columns between output fields
  -i, --ignore-file=FILE read ignore word list from FILE
  -o, --only-file=FILE read only word list from this FILE
   -a, --across print columns across rather than down, used together
                    with -COLUMN
  -c, --show-control-chars
                    use hat notation (^G) and octal backslash notation
  -d, --double-space
                    double space the output
   -b, --before attach the separator before instead of after
  -r, --regex interpret the separator as a regular expression
  -s, --separator=STRING use STRING as the separator instead of newline
   -b, --bytes count bytes rather than columns
  -s, --spaces break at spaces
  -w, --width=WIDTH use WIDTH columns instead of 80
   -b, --bytes=LIST select only these bytes
  -c, --characters=LIST select only these characters
  -d, --delimiter=DELIM use DELIM instead of TAB for field delimiter
   -b, --ignore-leading-blanks ignore leading blanks
  -d, --dictionary-order consider only blanks and alphanumeric characters
  -f, --ignore-case fold lower case to upper case characters
   -c, --crown-margin preserve indentation of first two lines
  -p, --prefix=STRING reformat only lines beginning with STRING,
                              reattaching the prefix to reformatted lines
  -s, --split-only split long lines, but do not refill
   -d, --delimiters=LIST reuse characters from LIST instead of TABs
  -s, --serial paste one file at a time instead of in parallel
   -e enable interpretation of backslash escapes (default)
  -E disable interpretation of backslash escapes
   -f omit the line of column headings in short format
  -w omit the user's full name in short format
  -i omit the user's full name and remote host in short format
  -q omit the user's full name, remote host and idle time
                  in short format
   -f same as -t fF, select floats
  -i same as -t dI, select decimal ints
  -l same as -t dL, select decimal longs
  -o same as -t o2, select octal 2-byte units
  -s same as -t d2, select decimal 2-byte units
  -x same as -t x2, select hexadecimal 2-byte units
   -f FILE FILE exists and is a regular file
  -g FILE FILE exists and is set-group-ID
  -G FILE FILE exists and is owned by the effective group ID
  -h FILE FILE exists and is a symbolic link (same as -L)
  -k FILE FILE exists and has its sticky bit set
   -f, --canonicalize            canonicalise by following every symlink in
                                every component of the given name recursively;
                                all but the last component must exist
  -e, --canonicalize-existing   canonicalise by following every symlink in
                                every component of the given name recursively,
                                all components must exist
   -f, --fields=LIST select only these fields; also print any line
                            that contains no delimiter character, unless
                            the -s option is specified
  -n (ignored)
   -h, --header=HEADER
                    use a centred HEADER instead of filename in page header,
                    -h "" prints a blank line, don't use -h""
  -i[CHAR[WIDTH]], --output-tabs[=CHAR[WIDTH]]
                    replace spaces with CHARs (TABs) to tab WIDTH (8)
  -J, --join-lines  merge full lines, turns off -W line truncation, no column
                    alignment, --sep-string[=STRING] sets separators
   -i, --inodes list inode information instead of block usage
  -k like --block-size=1K
  -l, --local limit listing to local file systems
      --no-sync do not invoke sync before getting usage info (default)
   -l, --login print system login processes
   -q, --count all login names and number of users logged on
  -r, --runlevel print current runlevel
  -s, --short print only name, line, and time (default)
  -t, --time print last system clock change
   -q, --quiet, --silent never print headers giving file names
  -v, --verbose always print headers giving file names
   -r, --references first field of each line is a reference
  -t, --typeset-mode - not implemented -
  -w, --width=NUMBER output width in columns, reference excluded
   -s, --only-delimited do not print lines not containing delimiters
      --output-delimiter=STRING use STRING as the output delimiter
                            the default is to use the input delimiter
   -s, --signal=SIGNAL, -SIGNAL
                   specify the name or number of the signal to be sent
  -l, --list list signal names, or convert signal names to/from numbers
  -t, --table print a table of signal information
   -s, --symbolic-link make symbolic links instead of copying
  -S, --suffix=SUFFIX override the usual backup suffix
  -t, --target-directory=DIRECTORY copy all SOURCE arguments into DIRECTORY
  -T, --no-target-directory treat DEST as a normal file
   -t equivalent to -vT
  -T, --show-tabs display TAB characters as ^I
  -u (ignored)
  -v, --show-nonprinting use ^ and M- notation, except for LFD and TAB
   -w, --check-chars=N compare no more than N characters in lines
   [:graph:] all printable characters, not including space
  [:lower:] all lower case letters
  [:print:] all printable characters, including space
  [:punct:] all punctuation characters
  [:space:] all horizontal or vertical whitespace
  [:upper:] all upper case letters
  [:xdigit:] all hexadecimal digits
  [=CHAR=] all characters which are equivalent to CHAR
   binary use binary I/O for data
   direct use direct I/O for data
   dsync use synchronised I/O for data
   noctty do not assign controlling terminal from file
   nofollow do not follow symlinks
   nonblock use non-blocking I/O
   none, off never make backups (even if --backup is given)
  numbered, t make numbered backups
  existing, nil numbered if numbered backups exist, simple otherwise
  simple, never always make simple backups
   sync likewise, but also for metadata
   text use text I/O for data
  * [-]iutf8 assume input characters are UTF-8 encoded
 %e %b %Y %e %b %H:%M , load average: %.2f Copy standard input to each FILE, and also to standard output.

  -a, --append append to the given FILEs, do not overwrite
  -i, --ignore-interrupts ignore interrupt signals
 Echo the STRING(s) to standard output.

  -n do not output the trailing newline
 Output who is currently logged in according to FILE.
If FILE is not specified, use %s. %s as FILE is common.

 Print certain system information. With no OPTION, same as -s.

  -a, --all print all information, in the following order,
                             except omit -p and -i if unknown:
  -s, --kernel-name print the kernel name
  -n, --nodename print the network node hostname
  -r, --kernel-release print the kernel release
 Print the file name of the terminal connected to standard input.

  -s, --silent, --quiet print nothing, only return an exit status
 Request cancelled Request not cancelled Usage: %s COMMAND [ARG]...
  or: %s OPTION
 Usage: %s EXPRESSION
  or: %s OPTION
 Usage: %s FILE
  or: %s OPTION
 Usage: %s FILE1 FILE2
  or: %s OPTION
 Usage: %s FORMAT [ARGUMENT]...
  or: %s OPTION
 Usage: %s [-s SIGNAL | -SIGNAL] PID...
  or: %s -l [SIGNAL]...
  or: %s -t [SIGNAL]...
 Usage: %s [NAME]
  or: %s OPTION
Print or set the hostname of the current system.

 Usage: %s [OPERAND]...
  or: %s OPTION
 Usage: %s [OPTION]... GROUP FILE...
  or: %s [OPTION]... --reference=RFILE FILE...
 Usage: %s [OPTION]... LAST
  or: %s [OPTION]... FIRST LAST
  or: %s [OPTION]... FIRST INCREMENT LAST
 Usage: %s [OPTION]... MODE[,MODE]... FILE...
  or: %s [OPTION]... OCTAL-MODE FILE...
  or: %s [OPTION]... --reference=RFILE FILE...
 Usage: %s [OPTION]... [+FORMAT]
  or: %s [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
 Usage: %s [OPTION]... [-T] SOURCE DEST
  or: %s [OPTION]... SOURCE... DIRECTORY
  or: %s [OPTION]... -t DIRECTORY SOURCE...
 Usage: %s [OPTION]... [-T] SOURCE DEST
  or: %s [OPTION]... SOURCE... DIRECTORY
  or: %s [OPTION]... -t DIRECTORY SOURCE...
  or: %s [OPTION]... -d DIRECTORY...
 Usage: %s [OPTION]... [FILE]...
  or: %s [-abcdfilosx]... [FILE] [[+]OFFSET[.][b]]
  or: %s --traditional [OPTION]... [FILE] [[+]OFFSET[.][b] [+][LABEL][.][b]]
 Usage: %s [OPTION]... [FILE]...
  or: %s [OPTION]... --files0-from=F
 Usage: %s [OPTION]... [INPUT]... (without -G)
  or: %s -G [OPTION]... [INPUT [OUTPUT]]
 Usage: %s [OPTION]... [OWNER][:[GROUP]] FILE...
  or: %s [OPTION]... --reference=RFILE FILE...
 Usage: %s [OPTION]... [USER]...

 Usage: %s [STRING]...
  or: %s OPTION
 Usage: %s [ignored command line arguments]
  or: %s OPTION
 Usage: test EXPRESSION
  or: test
  or: [ EXPRESSION ]
  or: [ ]
  or: [ OPTION
 With --follow (-f), tail defaults to following the file descriptor, which
means that even if a tail'ed file is renamed, tail will continue to track
its end.  This default behaviour is not desirable when you really want to
track the actual name of the file, not the file descriptor (e.g., log
rotation).  Use --follow=name in that case.  That causes tail to track the
named file in a way that accommodates renaming, removal and creation.
 Written by %s, %s, %s,
%s, %s, %s, %s,
%s, %s and others.
 Written by %s, %s, %s,
%s, %s, %s, %s,
%s and %s.
 Written by %s, %s, %s,
%s, %s, %s, %s
and %s.
 Written by %s, %s, %s,
%s, %s, %s and %s.
 Written by %s, %s, %s,
%s, %s and %s.
 Written by %s, %s, %s,
%s and %s.
 Written by %s, %s, %s
and %s.
 Written by %s, %s and %s.
 can't apply partial context to unlabelled file %s cannot both summarise and show all entries failed to canonicalise %s invalid option -- %c; -WIDTH is recognised only when it is the first
option; use -w N instead number in parallel must be non-zero unrecognised operand %s unrecognised prefix: %s warning: summarising is the same as using --max-depth=0 