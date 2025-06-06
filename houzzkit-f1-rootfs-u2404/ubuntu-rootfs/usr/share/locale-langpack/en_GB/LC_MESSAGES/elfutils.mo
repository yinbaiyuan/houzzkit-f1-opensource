��      0   �   %   �     D     L  P      |     }  "   �     �     �  Q   �  J   B  �  �    z     �  =   �  5   �  6   &  1   ]     �  "   �  *   �     �  -     !   >  K   `  >   �  2   �  Y     �  x     H  "   Y     |     �  P   �  I     �  U    >     [  <   s  4   �  5   �  0         L   "   _   )   �      �   /   �       �   L   !  >   h!  2   �!  Z   �!     	                       
                                                                                                     5"  T  h  <"  A          ����"  A          ���� 
File name table: %s%s%s: file format not recognized %s: File format not recognized %s: file format not recognized Also read file names to process from standard input, separated by ASCII NUL bytes Also read file names to process from standard input, separated by newlines Combine stripped files with separate symbols and debug information.

The first form puts the result in DEBUG-FILE if -o was not given.

MODULE arguments give file name patterns matching modules to process.
With -f these match the file name of the main (stripped) file (slashes are never special), otherwise they match the simple module names.  With no arguments, process all modules found.

Multiple modules are written to files under OUTPUT-DIRECTORY, creating subdirectories as needed.  With -m these files have simple module names, otherwise they have the name of the main file complete with directory underneath OUTPUT-DIRECTORY.

With -n no files are written, but one line to standard output for each module:
	START+SIZE BUILDID FILE DEBUGFILE MODULENAME
START and SIZE are hexadecimal giving the address bounds of the module.  BUILDID is hexadecimal for the build ID bits, or - if no ID is known; the hexadecimal may be followed by @0xADDR giving the address where the ID resides if that is known.  FILE is the file name found for the module, or - if none was found, or . if an ELF image is available but not from any named file.  DEBUGFILE is the separate debuginfo file name, or - if no debuginfo was found, or . if FILE contains the debug information. Determine the type of an ELF file.

All of the classification options must apply at the same time to a particular file.  Classification options can be negated using a "--not-" prefix.

Since modern ELF does not clearly distinguish between programs and dynamic shared objects, you should normally use either --executable or --shared to identify the primary purpose of a file.  Only one of the --shared and --executable checks can pass for a file.

If you want to know whether an ELF object might a program or a shared library (but could be both), then use --program or --library. Some ELF files will classify as both a program and a library.

If you just want to know whether an ELF file is loadable (as program or library) use --loadable.  Note that files that only contain (separate) debug information (--debug-only) are never --loadable (even though they might contain program headers).  Linux kernel modules are also not --loadable (in the normal sense).

Without any of the --print options, the program exits with status 0 if the requested checks pass for all input files, with 1 if a check fails for any file, and 2 if there is an environmental issue (such as a file read error or a memory allocation error).

When printing file names, the program exits with status 0 even if no file names are printed, and exits with status 2 if there is an environmental issue.

On usage error (e.g. a bad option was given), the program exits with a status code larger than 2.

The --quiet or -q option suppresses some error warning output, but doesn't change the exit status. Do not output file names File is an regular ELF object (not an archive/static library) If printing file names, print files that do not match If printing file names, print matching files (default) Match MODULE against file names, not module names Missing file name.
 No modules recognized in core file Only list module and file names, build IDs Prepend PATH to all file names Unwinding not supported for this architecture Use module rather than file names colorize the output.  WHEN defaults to 'always' or can be 'auto' or 'never' section [%2d] '%s': offset %zu: unrecognized attribute tag %u
 section [%2d] '%s': unrecognized attribute format
 zeroth section has nonzero link value while ELF header does not signal overflow in phnum
 Project-Id-Version: elfutils
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2023-11-18 12:30+0000
Last-Translator: Andi Chandler <Unknown>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Launchpad-Export-Date: 2025-01-30 17:57+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
Filename table: %s%s%s: file format not recognised %s: File format not recognised %s: file format not recognised Also read filenames to process from standard input, separated by ASCII NUL bytes Also read filenames to process from standard input, separated by newlines Combine stripped files with separate symbols and debug information.

The first form puts the result in DEBUG-FILE if -o was not given.

MODULE arguments give filename patterns matching modules to process.
With -f these match the filename of the main (stripped) file (slashes are never special), otherwise they match the simple module names.  With no arguments, process all modules found.

Multiple modules are written to files under OUTPUT-DIRECTORY, creating subdirectories as needed.  With -m these files have simple module names, otherwise they have the name of the main file complete with directory underneath OUTPUT-DIRECTORY.

With -n no files are written, but one line to standard output for each module:
	START+SIZE BUILDID FILE DEBUGFILE MODULENAME
START and SIZE are hexadecimal giving the address bounds of the module.  BUILDID is hexadecimal for the build ID bits, or - if no ID is known; the hexadecimal may be followed by @0xADDR giving the address where the ID resides if that is known.  FILE is the filename found for the module, or - if none was found, or . if an ELF image is available but not from any named file.  DEBUGFILE is the separate debuginfo filename, or - if no debuginfo was found, or . if FILE contains the debug information. Determine the type of an ELF file.

All of the classification options must apply at the same time to a particular file.  Classification options can be negated using a "--not-" prefix.

Since modern ELF does not clearly distinguish between programs and dynamic shared objects, you should normally use either --executable or --shared to identify the primary purpose of a file.  Only one of the --shared and --executable checks can pass for a file.

If you want to know whether an ELF object might a program or a shared library (but could be both), then use --program or --library. Some ELF files will classify as both a program and a library.

If you just want to know whether an ELF file is loadable (as program or library) use --loadable.  Note that files that only contain (separate) debug information (--debug-only) are never --loadable (even though they might contain program headers).  Linux kernel modules are also not --loadable (in the normal sense).

Without any of the --print options, the program exits with status 0 if the requested checks pass for all input files, with 1 if a check fails for any file, and 2 if there is an environmental issue (such as a file read error or a memory allocation error).

When printing filenames, the program exits with status 0 even if no filenames are printed, and exits with status 2 if there is an environmental issue.

On usage error (e.g. a bad option was given), the program exits with a status code larger than 2.

The --quiet or -q option suppresses some error warning output, but doesn't change the exit status. Do not output filenames File is a regular ELF object (not an archive/static library) If printing filenames, print files that do not match If printing filenames, print matching files (default) Match MODULE against filenames, not module names Missing filename.
 No modules recognised in core file Only list module and filenames, build IDs Prepend PATH to all filenames Unwinding isn't supported for this architecture Use module rather than filenames colourise the output.  WHEN defaults to 'always' or can be 'auto' or 'never' section [%2d] '%s': offset %zu: unrecognised attribute tag %u
 section [%2d] '%s': unrecognised attribute format
 zeroth section has non-zero link value while ELF header does not signal overflow in phnum
 PRIu64 section [%2d] '%s': offset %zu: unrecognized %s attribute value %
 section [%2d] '%s': offset %zu: unrecognised %s attribute value %
 