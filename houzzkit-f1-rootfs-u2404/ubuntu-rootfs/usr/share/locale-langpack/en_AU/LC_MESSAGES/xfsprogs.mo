��          �   %   �      p  �   q  �  e  r  J  0   �  4   �  5   #  2   Y  $   �  '   �     �  %   �     	  v   :	  z   �	  t   ,
      �
  '   �
  $   �
       
   *  %   5  &   [     �     �  )   �  *   �  "     �  8  �   �  �  �  s  �  0   .  4   _  5   �  2   �  $   �  '   "     J  %   j     �  u   �  y   !  s   �        '   0  $   X     }  
   �  %   �  &   �     �       )   .  *   X  "   �                                                                       
         	                                           
 Update file atime and mtime of the current file with nansecond precision.

 Usage: utimes atime_sec atime_nsec mtime_sec mtime_nsec.
 *_sec: Seconds elapsed since 1970-01-01 00:00:00 UTC.
 *_nsec: Nanoseconds since the corresponding *_sec.

 
 advise the page cache about access patterns expected for a mapping

 Modifies page cache behavior when operating on the current mapping.
 The range arguments are required by some advise commands ([*] below).
 With no arguments, the POSIX_MADV_NORMAL advice is implied.
 -d -- don't need these pages (POSIX_MADV_DONTNEED) [*]
 -r -- expect random page references (POSIX_MADV_RANDOM)
 -s -- expect sequential page references (POSIX_MADV_SEQUENTIAL)
 -w -- will need these pages (POSIX_MADV_WILLNEED) [*]
 Notes:
   NORMAL sets the default readahead setting on the file.
   RANDOM sets the readahead setting on the file to zero.
   SEQUENTIAL sets double the default readahead setting on the file.
   WILLNEED forces the maximum readahead.

 
 set allocation group free block list

 Example:

 agf 2 - move location to AGF in 2nd filesystem allocation group

 Located in the second sector of each allocation group, the AGF
 contains the root of two different freespace btrees:
 The 'cnt' btree keeps track freespace indexed on section size.
 The 'bno' btree tracks sections of freespace indexed on block number.
 
fatal error -- couldn't initialize XFS library
 %s %s filesystem failed to initialize
%s: Aborting.
 %s: %s filesystem failed to initialize
%s: Aborting.
 %s: couldn't initialize XFS library
%s: Aborting.
 %s: filesystem failed to initialize
 Couldn't initialize global thread mask
 Error initializing btree buf 1
 Error initializing the realtime space Error initializing wbuf 0
 Warning:  group quota information was cleared.
Group quotas can not be enforced until limit information is recreated.
 Warning:  project quota information was cleared.
Project quotas can not be enforced until limit information is recreated.
 Warning:  user quota information was cleared.
User quotas can not be enforced until limit information is recreated.
 couldn't initialize XFS library
 failed to initialize prefetch cond var
 failed to initialize prefetch mutex
 initialize realtime bitmap randomized reinitializing realtime bitmap inode
 reinitializing realtime summary inode
 reinitializing root directory
 summarize filesystem ownership would reinitialize realtime bitmap inode
 would reinitialize realtime summary inode
 would reinitialize root directory
 Project-Id-Version: xfsprogs
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2020-03-29 14:20+0000
Last-Translator: Anthony Harrington <Unknown>
Language-Team: English (Australia) <en_AU@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:26+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
 Update file atime and mtime of the current file with nanosecond precision.

 Usage: utimes atime_sec atime_nsec mtime_sec mtime_nsec.
 *_sec: Seconds elapsed since 1970-01-01 00:00:00 UTC.
 *_nsec: Nanoseconds since the corresponding *_sec.

 
 advise the page cache about access patterns expected for a mapping

 Modifies page cache behaviour when operating on the current mapping.
 The range arguments are required by some advise commands ([*] below).
 With no arguments, the POSIX_MADV_NORMAL advice is implied.
 -d -- don't need these pages (POSIX_MADV_DONTNEED) [*]
 -r -- expect random page references (POSIX_MADV_RANDOM)
 -s -- expect sequential page references (POSIX_MADV_SEQUENTIAL)
 -w -- will need these pages (POSIX_MADV_WILLNEED) [*]
 Notes:
   NORMAL sets the default readahead setting on the file.
   RANDOM sets the readahead setting on the file to zero.
   SEQUENTIAL sets double the default readahead setting on the file.
   WILLNEED forces the maximum readahead.

 
 set allocation group free block list

 Example:

 agf 2 - move location to AGF in 2nd file-system allocation group

 Located in the second sector of each allocation group, the AGF
 contains the root of two different freespace btrees:
 The 'cnt' btree keeps track freespace indexed on section size.
 The 'bno' btree tracks sections of freespace indexed on block number.
 
fatal error -- couldn't initialise XFS library
 %s %s filesystem failed to initialise
%s: Aborting.
 %s: %s filesystem failed to initialise
%s: Aborting.
 %s: couldn't initialise XFS library
%s: Aborting.
 %s: filesystem failed to initialise
 Couldn't initialise global thread mask
 Error initialising btree buf 1
 Error initialising the realtime space Error initialising wbuf 0
 Warning:  group quota information was cleared.
Group quotas cannot be enforced until limit information is recreated.
 Warning:  project quota information was cleared.
Project quotas cannot be enforced until limit information is recreated.
 Warning:  user quota information was cleared.
User quotas cannot be enforced until limit information is recreated.
 couldn't initialise XFS library
 failed to initialise prefetch cond var
 failed to initialise prefetch mutex
 initialise realtime bitmap randomised reinitialising realtime bitmap inode
 reinitialising realtime summary inode
 reinitialising root directory
 summarise filesystem ownership would reinitialise realtime bitmap inode
 would reinitialise realtime summary inode
 would reinitialise root directory
 