��    4      �  G   \      x  w   y    �  b  �  >   Y  �   �  �   v  �   �  �   �	     }
  �   �  �  [  �   �    �  �  �  F   }  <   �  �      �  >   �  *   �  L     	   l     v     �     �  �   �  W  T     �     �  I   �  �     �  �  ;   Z  3   �  /   �  +   �  '   &  #   N     r     �  0   �  *   �  3   
     >     V  ]   p  )   �     �       7   (  "   `  �  �  }   T     �   c  �!  >   B#  �   �#  �   `$  �   �$  �   �%  "  j&  �   �'  �  I(  �   �)    �*  �  �+  E   l-  $   �-  �  �-    �/  >   �1  *   �1  L   �1  	   B2     L2     X2     x2  �   �2  X  +3     �4     �4  I   �4  �   �4  �  5  :   57  2   p7  .   �7  *   �7  &   �7  "   $8     G8     f8  1   �8  *   �8  4   �8     9     +9  ]   E9  )   �9     �9     �9  7   �9  "   5:        +                   ,                  *      /   	                        &                       #   4                  .                       $   )      (                2   3   1      %   
           "          -             0       '      !    
A field is a run of blanks (usually spaces and/or TABs), then non-blank
characters.  Fields are skipped before chars.
 
Both MAJOR and MINOR must be specified when TYPE is b, c, or u, and they
must be omitted when TYPE is p.  If MAJOR or MINOR begins with 0x or 0X,
it is interpreted as hexadecimal; otherwise, if it begins with 0, as octal;
otherwise, as decimal.  TYPE may be:
 
By default, sparse SOURCE files are detected by a crude heuristic and the
corresponding DEST file is made sparse as well.  That is the behavior
selected by --sparse=auto.  Specify --sparse=always to create a sparse DEST
file whenever the SOURCE file contains a long enough sequence of zero bytes.
Use --sparse=never to inhibit creation of sparse files.
 
If -e is in effect, the following sequences are recognized:

 
If FILE is specified, read it to determine which colors to use for which
file types and extensions.  Otherwise, a precompiled database is used.
For details on the format of these files, run 'dircolors --print-database'.
 
NOTE: [ honors the --help and --version options, but test does not.
test treats each of those as it treats any other nonempty STRING.
 
The MODE argument of --cached can be: always, never, or default.
'always' will use cached attributes if available, while
'never' will try to synchronize with the latest attributes, and
'default' will leave it up to the underlying file system.
 
Using -s ignores -L and -P.  Otherwise, the last option specified controls
behavior when a TARGET is a symbolic link, defaulting to %s.
 
Using color to distinguish file types is disabled both by default and
with --color=never.  With --color=auto, ls emits color codes only when
standard output is connected to a terminal.  The LS_COLORS environment
variable can change the settings.  Use the dircolors(1) command to set it.
 
With no options, produce three-column output.  Column one contains
lines unique to FILE1, column two contains lines unique to FILE2,
and column three contains lines common to both files.
       --files0-from=F   summarize device usage of the
                          NUL-terminated file names specified in file F;
                          if F is -, then read names from standard input
  -H                    equivalent to --dereference-args (-D)
  -h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
      --inodes          list inode usage information instead of block usage
       --lookup      attempt to canonicalize hostnames via DNS
  -m                only hostname and user associated with stdin
  -p, --process     print active processes spawned by init
   -a, --all                  do not ignore entries starting with .
  -A, --almost-all           do not list implied . and ..
      --author               with -l, print the author of each file
  -b, --escape               print C-style escapes for nongraphic characters
   -f, --canonicalize            canonicalize by following every symlink in
                                every component of the given name recursively;
                                all but the last component must exist
  -e, --canonicalize-existing   canonicalize by following every symlink in
                                every component of the given name recursively,
                                all components must exist
   -f, --file-system      sync the file systems that contain the files
   -g                         like -l, but do not list owner
   -h, --header=HEADER
                    use a centered HEADER instead of filename in page header,
                    -h "" prints a blank line, don't use -h""
  -i[CHAR[WIDTH]], --output-tabs[=CHAR[WIDTH]]
                    replace spaces with CHARs (TABs) to tab WIDTH (8)
  -J, --join-lines  merge full lines, turns off -W line truncation, no column
                    alignment, --sep-string[=STRING] sets separators
   -m, --canonicalize-missing    canonicalize by following every symlink in
                                every component of the given name recursively,
                                without requirements on components existence
  -n, --no-newline              do not output the trailing delimiter
  -q, --quiet
  -s, --silent                  suppress most error messages (on by default)
  -v, --verbose                 report error messages
  -z, --zero                    end each output line with NUL, not newline
   -t, --tabs=LIST  use comma separated list of tab positions.
   dsync     use synchronized I/O for data
  * [-]ixany      let any character restart output, not only start character
 %b %e  %Y %b %e %H:%M %s: unrecognized option '%s%s'
 Hangup License GPLv3+: GNU GPL version 3 or later <%s>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
 Output commands to set the LS_COLORS environment variable.

Determine format of output:
  -b, --sh, --bourne-shell    output Bourne shell code to set LS_COLORS
  -c, --csh, --c-shell        output C shell code to set LS_COLORS
  -p, --print-database        output defaults
      --print-ls-colors       output fully escaped colors for display
 Request canceled Request not canceled Summarize device usage of the set of FILEs, recursively for directories.
 Synchronize cached writes to persistent storage

If one or more files are specified, sync only them,
or their containing file systems.

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
 can't apply partial context to unlabeled file %s cannot both summarize and show all entries delimiter list ends with an unescaped backslash: %s error canonicalizing %s failed to canonicalize %s invalid option -- %c; -WIDTH is recognized only when it is the first
option; use -w N instead unrecognized --preserve-root argument: %s unrecognized operand %s unrecognized prefix: %s warning: summarizing is the same as using --max-depth=0 warning: unrecognized escape '\%c' Project-Id-Version: coreutils
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2024-10-12 16:30+0000
Last-Translator: Andi Chandler <Unknown>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Launchpad-Export-Date: 2025-01-30 16:37+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
A field is a run of blanks (usually spaces and/or TABs) followed by non-blank
characters.  Fields are skipped before chars.
 
Both MAJOR and MINOR must be specified when TYPE is b, c, or u, and they
must be omitted when TYPE is p.  If MAJOR or MINOR begins with 0x or 0X,
it is interpreted as hexadecimal; if it begins with 0, as octal;
otherwise, it is interpreted as decimal.  TYPE may be:
 
By default, sparse SOURCE files are detected by a crude heuristic and the
corresponding DEST file is made sparse as well.  That is the behaviour
selected by --sparse=auto.  Specify --sparse=always to create a sparse DEST
file whenever the SOURCE file contains a long enough sequence of zero bytes.
Use --sparse=never to inhibit creation of sparse files.
 
If -e is in effect, the following sequences are recognised:

 
If FILE is specified, read it to determine which colours to use for which
file types and extensions.  Otherwise, a precompiled database is used.
For details on the format of these files, run 'dircolors --print-database'.
 
NOTE: [ honours the --help and --version options, but test does not.
test treats each of those as it treats any other non-empty STRING.
 
The MODE argument of --cached can be: always, never, or default.
'always' will use cached attributes if available, while
'never' will try to synchronise with the latest attributes, and
'default' will leave it up to the underlying file system.
 
Using -s ignores -L and -P.  Otherwise, the last option specified controls
behaviour when a TARGET is a symbolic link, defaulting to %s.
 
Using colour to distinguish file types is disabled both by default and
with --color=never.  With --color=auto, ls emits colour codes only when
standard output is connected to a terminal.  The LS_COLORS environment
variable can change the settings.  Use the dircolors(1) command to set it.
 
With no options, produce three-column output.  Column one contains
lines unique to FILE1, column two contains lines unique to FILE2
and column three contains lines common to both files.
       --files0-from=F   summarise device usage of the
                          NUL-terminated file names specified in file F;
                          if F is -, then read names from standard input
  -H                    equivalent to --dereference-args (-D)
  -h, --human-readable  print sizes in human-readable format (e.g., 1K 234M 2G)
      --inodes          list inode usage information instead of block usage
       --lookup      attempt to canonicalise hostnames via DNS
  -m                only hostname and user associated with stdin
  -p, --process     print active processes spawned by init
   -a, --all                  do not ignore entries starting with .
  -A, --almost-all           do not list implied . and ..
      --author               with -l, print the author of each file
  -b, --escape               print C-style escapes for non-graphic characters
   -f, --canonicalize            canonicalise by following every symlink in
                                every component of the given name recursively;
                                all but the last component must exist
  -e, --canonicalize-existing   canonicalise by following every symlink in
                                every component of the given name recursively,
                                all components must exist
   -f, --file-system      sync the filesystems that contain the files
   -g like -l, but do not list owner
   -h, --header=HEADER
                    use a centred HEADER instead of file-name in page header,
                    -h "" prints a blank line, don't use -h""
  -i[CHAR[WIDTH]], --output-tabs[=CHAR[WIDTH]]
                    replace spaces with CHARs (TABs) to tab WIDTH (8)
  -J, --join-lines  merge full lines, turns off -W line truncation, no column
                    alignment, --sep-string[=STRING] sets separators
   -m, --canonicalize-missing    canonicalise by following every symlink in
                                every component of the given name recursively,
                                without requirements on components existence
  -n, --no-newline              do not output the trailing delimiter
  -q, --quiet
  -s, --silent                  suppress most error messages (on by default)
  -v, --verbose                 report error messages
  -z, --zero                    end each output line with NUL, not newline
   -t, --tabs=LIST  use comma-separated list of tab positions.
   dsync     use synchronised I/O for data
  * [-]ixany      let any character restart output, not just start character
 %e %b  %Y %e %b %H:%M %s: unrecognised option '%s%s'
 Hang up Licence GPLv3+: GNU GPL version 3 or later <%s>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
 Output commands to set the LS_COLORS environment variable.

Determine format of output:
  -b, --sh, --bourne-shell    output Bourne shell code to set LS_COLORS
  -c, --csh, --c-shell        output C shell code to set LS_COLORS
  -p, --print-database        output defaults
      --print-ls-colors       output fully escaped colours for display
 Request cancelled Request not cancelled Summarise device usage of the set of FILEs, recursively for directories.
 Synchronise cached writes to persistent storage

If one or more files are specified, sync only them,
or their containing file systems.

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
 can't apply partial context to unlabelled file %s cannot both summarise and show all entries delimiter list ends with a non-escaped backslash: %s error canonicalising %s failed to canonicalise %s invalid option -- %c; -WIDTH is recognised only when it is the first
option; use -w N instead unrecognised --preserve-root argument: %s unrecognised operand %s unrecognised prefix: %s warning: summarising is the same as using --max-depth=0 warning: unrecognised escape '\%c' 