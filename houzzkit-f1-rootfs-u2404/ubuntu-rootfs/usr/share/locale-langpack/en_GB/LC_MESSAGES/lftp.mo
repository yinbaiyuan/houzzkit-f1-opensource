��          �            x  �  y      >     _  .   |     �  <   �       �    k  �  \  B	  �  �
  X  0  d   �     �       �    �  �  !   �     �  .   �     �  <        Z  �  n  k  )  \  �  �  �  X  �  d   �     A     Y                                    	   
                                        
Mirror specified remote directory to local directory

 -R, --reverse          reverse mirror (put files)
Lots of other options are documented in the man page lftp(1).

When using -R, the first directory is local and the second is remote.
If the second directory is omitted, basename of the first directory is used.
If both directories are omitted, current local and remote directories are used.

See the man page lftp(1) for a complete documentation.
 %s: Operand missed for `expire'
 %s: Operand missed for size
 %s: summarizing conflicts with --max-depth=%i
 %s: unrecognized option '%s%s'
 %s: warning: summarizing is the same as using --max-depth=0
 File name missed.  Summarize disk usage.
 -a, --all             write counts for all files, not just directories
     --block-size=SIZ  use SIZ-byte blocks
 -b, --bytes           print size in bytes
 -c, --total           produce a grand total
 -d, --max-depth=N     print the total for a directory (or file, with --all)
                       only if it is N or fewer levels below the command
                       line argument;  --max-depth=0 is the same as
                       --summarize
 -F, --files           print number of files instead of sizes
 -h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
 -H, --si              likewise, but use powers of 1000 not 1024
 -k, --kilobytes       like --block-size=1024
 -m, --megabytes       like --block-size=1048576
 -S, --separate-dirs   do not include size of subdirectories
 -s, --summarize       display only a total for each argument
     --exclude=PAT     exclude files that match PAT
 Upload <lfile> with remote name <rfile>.
 -o <rfile> specifies remote file name (default - basename of lfile)
 -c  continue, reput
     it requires permission to overwrite remote files
 -E  delete local files after successful transfer (dangerous)
 -a  use ascii mode (binary is the default)
 -O <base> specifies base directory or URL where files should be placed
 Upload files with wildcard expansion
 -c  continue, reput
 -d  create directories the same as in file names and put the
     files into them instead of current directory
 -E  delete local files after successful transfer (dangerous)
 -a  use ascii mode (binary is the default)
 -O <base> specifies base directory or URL where files should be placed
 bookmark command controls bookmarks

The following subcommands are recognized:
  add <name> [<loc>] - add current place or given location to bookmarks
                       and bind to given name
  del <name>         - remove bookmark with the name
  edit               - start editor on bookmarks file
  import <type>      - import foreign bookmarks
  list               - list bookmarks (default)
 cache command controls local memory cache

The following subcommands are recognized:
  stat        - print cache status (default)
  on|off      - turn on/off caching
  flush       - flush cache
  size <lim>  - set memory limit
  expire <Nx> - set cache expiration time to N seconds (x=s)
                minutes (x=m) hours (x=h) or days (x=d)
 cat - output remote files to stdout (can be redirected)
 -b  use binary mode (ascii is the default)
 next announce in %s unrecognized option `%s' Project-Id-Version: lftp
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2022-04-08 16:04+0000
Last-Translator: Anthony Harrington <Unknown>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:06+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
Mirror specified remote directory to local directory

 -R, --reverse          reverse mirror (put files)
Lots of other options are documented in the man page lftp(1).

When using -R, the first directory is local and the second is remote.
If the second directory is omitted, the basename of the first directory is used.
If both directories are omitted, current local and remote directories are used.

See the man page lftp(1) for the complete documentation.
 %s: Operand missing for `expire'
 %s: Operand missing for size
 %s: summarising conflicts with --max-depth=%i
 %s: unrecognised option '%s%s'
 %s: warning: summarising is the same as using --max-depth=0
 File name missing.  Summarise disk usage.
 -a, --all             write counts for all files, not just directories
     --block-size=SIZ  use SIZ-byte blocks
 -b, --bytes           print size in bytes
 -c, --total           produce a grand total
 -d, --max-depth=N     print the total for a directory (or file, with --all)
                       only if it is N or fewer levels below the command
                       line argument;  --max-depth=0 is the same as
                       --summarize
 -F, --files           print number of files instead of sizes
 -h, --human-readable  print sizes in human readable format (e.g., 1K 234M 2G)
 -H, --si              likewise, but use powers of 1000 not 1024
 -k, --kilobytes       like --block-size=1024
 -m, --megabytes       like --block-size=1048576
 -S, --separate-dirs   do not include size of subdirectories
 -s, --summarize       display only a total for each argument
     --exclude=PAT     exclude files that match PAT
 Upload <lfile> with remote name <rfile>.
 -o <rfile> specifies remote file name (default - basename of lfile)
 -c  continue, reput
     it requires permission to overwrite remote files
 -E  delete local files after successful transfer (dangerous)
 -a  use ASCII mode (binary is the default)
 -O <base> specifies base directory or URL where files should be placed
 Upload files with wildcard expansion
 -c  continue, reput
 -d  create directories the same as in file names and put the
     files into them instead of current directory
 -E  delete local files after successful transfer (dangerous)
 -a  use ASCII mode (binary is the default)
 -O <base> specifies base directory or URL where files should be placed
 bookmark command controls bookmarks

The following subcommands are recognised:
  add <name> [<loc>] - add current place or given location to bookmarks
                       and bind to given name
  del <name>         - remove bookmark with the name
  edit               - start editor on bookmarks file
  import <type>      - import foreign bookmarks
  list               - list bookmarks (default)
 cache command controls local memory cache

The following subcommands are recognised:
  stat        - print cache status (default)
  on|off      - turn on/off caching
  flush       - flush cache
  size <lim>  - set memory limit
  expire <Nx> - set cache expiration time to N seconds (x=s)
                minutes (x=m) hours (x=h) or days (x=d)
 cat - output remote files to stdout (can be redirected)
 -b  use binary mode (ASCII is the default)
 next announcement in %s unrecognised option `%s' 