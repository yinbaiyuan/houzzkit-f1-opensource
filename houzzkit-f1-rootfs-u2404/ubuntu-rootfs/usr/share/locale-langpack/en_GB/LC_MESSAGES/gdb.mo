��    g      T  �   �      �  ,   �  %   �  �  	     �
     �
  "     $   +  4   P  U   �     �     �  "   �  .     1   L  '   ~  #   �  ,   �  -   �  #   %     I  -   f  %   �  9   �  C   �  \   8  ]   �  C   �  -   7  /   e  /   �     �  7   �  -     '   G     o  G   �    �    �  3   �    .     :     X  0   g     �     �  #   �  2   �       6   :  @   q  7   �  A   �  [  ,  ^  �  +   �  "     �  6    �  C  �   �   "  �   �"  (   �#  '   �#  '   �#  >   $  &   K$  3   r$  ,   �$  G   �$  *   %  &   F%     m%  ,   �%  !   �%  �   �%  '   �&  /   �&  &   �&     '  1   '  6   P'  )   �'  )   �'     �'     �'     �'  .   (     ?(  !   _(     �(  &   �(  4   �(     �(  !   )  #   5)     Y)  (   v)     �)     �)  /   �)  1   *     4*  �  Q*  ,   �+  %   ',  �  M,     ".     A.  "   Q.  $   t.  4   �.  U   �.  	   $/     ./  "   E/  .   h/  1   �/  '   �/  #   �/  ,   0  -   B0  #   p0     �0  -   �0  %   �0  :   1  C   @1  \   �1  ]   �1  C   ?2  -   �2  /   �2  /   �2     3  6   -3  -   d3  '   �3     �3  G   �3    4    15  2   E6    x6     �7     �7  0   �7     �7     �7  #   8  2   38     f8  7   �8  @   �8  8   �8  A   79  \  y9  ^  �<  +   5A  "   aA  �  �A    C  E  &D  �   lE  �   PF  (   �F  '   G  '   6G  >   ^G  &   �G  3   �G  ,   �G  G   %H  *   mH  &   �H     �H  ,   �H  !   I  �   -I  '   �I  /   J  &   @J  	   gJ  1   qJ  6   �J  )   �J  )   K     .K     >K     LK  .   eK     �K  !   �K     �K  &   �K  4   L     RL  !   hL  #   �L     �L  (   �L     �L     M  /   'M  1   WM     �M               
       G      3       M   L   *   U   '          4                  )          R   	                 I      C   [   X   H       V      +   ?   8   O      J          /             g      Q       &           f              (      =      2      A       "   %   N   6   1       P       T   ,   9      ]      -                  Y   <   B       e   0           #   a   b   D   7   :   >       _   $   F              c   ;          \   `   K      !       S       d   W   E   Z   .      5   ^      @               "%s": no core file handler recognizes format '%s' is not a recognized file format. (A "base name" is the name of a file with the directory part removed.
Example: The base name of "/home/user/hello.c" is "hello.c".)
If set, GDB will canonicalize file names (e.g., expand symlinks)
before comparing them.  Canonicalization is an expensive operation,
but it allows the same file be known by more than one base name.
If not set (the default), all source files are assumed to have just
one base name, and gdb will do file name comparisons more efficiently. <optimized out or zero length> <optimized out> Architecture `%s' not recognized.
 Architecture of file not recognized. Attempt to assign to a value that was optimized out. Can't do read-modify-write to update bitfield; containing word has been optimized out Canceled Canceled the download Cannot initialize libthread_db: %s Cannot initialize thread debugging library: %s Cannot instantiate printer for default visualizer Canonicalized file name given to execve Command object already initialized. Could not evaluate visualizer expression: %s Could not locate initialization function: %s. Could not recognize DWARF regnum %d Couldn't initialize WINSOCK. Couldn't recognize %s registers in core file. Couldn't recognize signal trampoline. Debugger's behavior regarding pending breakpoints is %s.
 Disabling randomization of debuggee's virtual address space is %s.
 Disabling randomization of debuggee's virtual address space is unsupported on
this platform. Disabling randomization of debuggee's virtual address space is unsupported on
this platform.
 Enable or disable an optimization trusting PAD types over XVS types Enabled packet %s (%s) not recognized by stub Error disabling address space randomization: %s Error restoring address space randomization: %s Event type not recognized.
 Explicitly sized type can not contain non-bitfield "%s" Failed to initialize (didn't receive packet). Failed to initialize new interp "%s" %s Failed to initialize. GDB bug: target.c (gdb_signal_from_host): unrecognized real-time signal GDB can sometimes determine the values of function arguments at entry,
in addition to their current values.  This option tells GDB whether
to print the current value, the value at entry (marked as val@entry),
or both.  Note that one or both of these values may be <optimized out>. If on, an unrecognized breakpoint location will cause gdb to create a
pending breakpoint.  If off, an unrecognized breakpoint location results in
an error.  If auto, an unrecognized breakpoint location results in a
user-query to see if a pending breakpoint should be created. Implicitly sized type can not contain bitfield "%s" Initialize a convenience variable if necessary.
init-if-undefined VARIABLE = EXPRESSION
Set an internal VARIABLE to the result of the EXPRESSION if it does not
exist or does not contain a value.  The EXPRESSION is not evaluated if the
VARIABLE is already initialized. Interpreter `%s' unrecognized Missing nul SO Operator `%c' not recognized on expression `%s'. Optimized out Register %d was optimized out Reinitialize source path to empty?  Remote board reset, debug protocol re-initialized. Section index is uninitialized Set debugger's behavior regarding pending breakpoints. Set disabling of debuggee's virtual address space randomization. Show debugger's behavior regarding pending breakpoints. Show disabling of debuggee's virtual address space randomization. Specify how to handle a signal.
Args are signals and actions to apply to those signals.
Symbolic signals (e.g. SIGSEGV) are recommended but numeric signals
from 1-15 are allowed for compatibility with old versions of GDB.
Numeric ranges may be specified with the form LOW-HIGH (e.g. 1-5).
The special arg "all" is recognized to mean all signals except those
used by the debugger, typically SIGTRAP and SIGINT.
Recognized actions include "s" (toggles between stop and nostop),
"r" (toggles between print and noprint), "i" (toggles between pass and nopass), "Q" (noprint)
Stop means reenter debugger if this signal happens (implies print).
Print means print a message if this signal happens.
Pass means let program see this signal; otherwise program doesn't know.
Ignore is a synonym for nopass and noignore is a synonym for pass.
Pass and Stop may be combined. Specify how to handle signals.
Usage: handle SIGNAL [ACTIONS]
Args are signals and actions to apply to those signals.
If no actions are specified, the current settings for the specified signals
will be displayed instead.

Symbolic signals (e.g. SIGSEGV) are recommended but numeric signals
from 1-15 are allowed for compatibility with old versions of GDB.
Numeric ranges may be specified with the form LOW-HIGH (e.g. 1-5).
The special arg "all" is recognized to mean all signals except those
used by the debugger, typically SIGTRAP and SIGINT.

Recognized actions include "stop", "nostop", "print", "noprint",
"pass", "nopass", "ignore", or "noignore".
Stop means reenter debugger if this signal happens (implies print).
Print means print a message if this signal happens.
Pass means let program see this signal; otherwise program doesn't know.
Ignore is a synonym for nopass and noignore is a synonym for pass.
Pass and Stop may be combined.

Multiple signals may be specified.  Signal numbers and signal names
may be interspersed with actions, with the actions being performed for
all signals cumulatively specified. Storage class %d not recognized during scan Template argument is optimized out The program being debugged entered a std::terminate call, most likely
caused by an unhandled C++ exception.  GDB blocked this call in order
to prevent the program from being terminated, and has restored the
context to its original state before the call.
To change this behaviour use "set unwind-on-terminating-exception off".
Evaluation of the expression containing the function (%s)
will be abandoned. The program being debugged was signaled while in a function called from GDB.
GDB has restored the context to what it was before the call.
To change this behavior use "set unwindonsignal off".
Evaluation of the expression containing the function
(%s) will be abandoned. The program being debugged was signaled while in a function called from GDB.
GDB remains in the frame where the signal was received.
To change this behavior use "set unwindonsignal on".
Evaluation of the expression containing the function
(%s) will be abandoned.
When the function is done executing, GDB will silently stop. This is the maximum number of characters GDB will ignore when trying to
synchronize with the remote system.  A value of -1 means that there is no
limit. (Note that these characters are printed out even though they are
ignored.) Unable to find dynamic linker breakpoint function.
GDB will be unable to debug shared library initializers
and track explicitly loaded dynamic code. Unrecognized %d-bit floating-point type. Unrecognized DWARF opcode 0x%02x at %ld Unrecognized breakpoint/watchpoint type Unrecognized char '%c' in tracepoint definition, skipping rest Unrecognized cross-reference type `%c' Unrecognized escape character \%c in format string. Unrecognized format specifier '%c' in printf Unrecognized option '%s' to info macro command.  Try "help info macro". Unrecognized or ambiguous flag word: "%s". Unrecognized range check setting: "%s" Unrecognized storage class %d. Unrecognized tracepoint piece '%c', ignoring Unrecognized watch register style When this mode is on (which is the default), randomization of the virtual
address space is disabled.  Standalone programs run with the randomization
enabled by default on some platforms. `%s' has been optimized out, cannot use `%s' is optimized away and cannot be collected. auto-load: And canonicalized as "%s".
 canceled field %s is nonexistent or has been optimized out internal error: string "%s" failed to be canonicalized mips_register_to_value: unrecognized case mips_value_to_register: unrecognized case missing nul SO optimized out port 0x%04x, behavior:  print_bp_stop_message: unrecognized enum value sect_index_data not initialized sect_index_rodata not initialized sect_index_text not initialized static field %s has been optimized out static field `%s' has been optimized out, cannot use too many initializers unrecognized .gcc_compiled_longXX unrecognized DW_MACFINO opcode 0x%x unrecognized attribute: `%s' unrecognized bitness `%c' for probe `%s' unrecognized character type unrecognized flag '%c' unrecognized item "%s" in "qSupported" response unrecognized version `%d' in .debug_macro section value has been optimized out Project-Id-Version: crash
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2020-04-10 21:55+0000
Last-Translator: Anthony Harrington <Unknown>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:29+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 "%s": no core file handler recognises format '%s' is not a recognised file format. (A "base name" is the name of a file with the directory part removed.
Example: The base name of "/home/user/hello.c" is "hello.c".)
If set, GDB will canonicalise file names (e.g., expand symlinks)
before comparing them.  Canonicalisation is an expensive operation,
but it allows the same file be known by more than one base name.
If not set (the default), all source files are assumed to have just
one base name, and gdb will do file name comparisons more efficiently. <optimised out or zero length> <optimised out> Architecture `%s' not recognised.
 Architecture of file not recognised. Attempt to assign to a value that was optimised out. Can't do read-modify-write to update bitfield; containing word has been optimised out Cancelled Cancelled the download Cannot initialise libthread_db: %s Cannot initialise thread debugging library: %s Cannot instantiate printer for default visualiser Canonicalised file name given to execve Command object already initialised. Could not evaluate visualiser expression: %s Could not locate initialisation function: %s. Could not recognise DWARF regnum %d Couldn't initialise WINSOCK. Couldn't recognise %s registers in core file. Couldn't recognise signal trampoline. Debugger's behaviour regarding pending breakpoints is %s.
 Disabling randomisation of debuggee's virtual address space is %s.
 Disabling randomisation of debuggee's virtual address space is unsupported on
this platform. Disabling randomisation of debuggee's virtual address space is unsupported on
this platform.
 Enable or disable an optimisation trusting PAD types over XVS types Enabled packet %s (%s) not recognised by stub Error disabling address space randomisation: %s Error restoring address space randomisation: %s Event type not recognised.
 Explicitly sized type cannot contain non-bitfield "%s" Failed to initialise (didn't receive packet). Failed to initialise new interp "%s" %s Failed to initialise. GDB bug: target.c (gdb_signal_from_host): unrecognised real-time signal GDB can sometimes determine the values of function arguments at entry,
in addition to their current values.  This option tells GDB whether
to print the current value, the value at entry (marked as val@entry),
or both.  Note that one or both of these values may be <optimised out>. If on, an unrecognised breakpoint location will cause gdb to create a
pending breakpoint.  If off, an unrecognised breakpoint location results in
an error.  If auto, an unrecognised breakpoint location results in a
user-query to see if a pending breakpoint should be created. Implicitly sized type cannot contain bitfield "%s" Initialise a convenience variable if necessary.
init-if-undefined VARIABLE = EXPRESSION
Set an internal VARIABLE to the result of the EXPRESSION if it does not
exist or does not contain a value.  The EXPRESSION is not evaluated if the
VARIABLE is already initialised. Interpreter `%s' unrecognised Missing null SO Operator `%c' not recognised on expression `%s'. Optimised out Register %d was optimised out Reinitialise source path to empty?  Remote board reset, debug protocol re-initialised. Section index is uninitialised Set debugger's behaviour regarding pending breakpoints. Set disabling of debuggee's virtual address space randomisation. Show debugger's behaviour regarding pending breakpoints. Show disabling of debuggee's virtual address space randomisation. Specify how to handle a signal.
Args are signals and actions to apply to those signals.
Symbolic signals (e.g. SIGSEGV) are recommended but numeric signals
from 1-15 are allowed for compatibility with old versions of GDB.
Numeric ranges may be specified with the form LOW-HIGH (e.g. 1-5).
The special arg "all" is recognised to mean all signals except those
used by the debugger, typically SIGTRAP and SIGINT.
Recognised actions include "s" (toggles between stop and nostop),
"r" (toggles between print and noprint), "i" (toggles between pass and nopass), "Q" (noprint)
Stop means re-enter debugger if this signal happens (implies print).
Print means print a message if this signal happens.
Pass means let program see this signal; otherwise program doesn't know.
Ignore is a synonym for nopass and noignore is a synonym for pass.
Pass and Stop may be combined. Specify how to handle signals.
Usage: handle SIGNAL [ACTIONS]
Args are signals and actions to apply to those signals.
If no actions are specified, the current settings for the specified signals
will be displayed instead.

Symbolic signals (e.g. SIGSEGV) are recommended but numeric signals
from 1-15 are allowed for compatibility with old versions of GDB.
Numeric ranges may be specified with the form LOW-HIGH (e.g. 1-5).
The special arg "all" is recognised to mean all signals except those
used by the debugger, typically SIGTRAP and SIGINT.

Recognised actions include "stop", "nostop", "print", "noprint",
"pass", "nopass", "ignore", or "noignore".
Stop means reenter debugger if this signal happens (implies print).
Print means print a message if this signal happens.
Pass means let program see this signal; otherwise program doesn't know.
Ignore is a synonym for nopass and noignore is a synonym for pass.
Pass and Stop may be combined.

Multiple signals may be specified.  Signal numbers and signal names
may be interspersed with actions, with the actions being performed for
all signals cumulatively specified. Storage class %d not recognised during scan Template argument is optimised out The program being debugged entered a std::terminate call, most likely
caused by an unhandled C++ exception.  GDB blocked this call in order
to prevent the program from being terminated, and has restored the
context to its original state before the call.
To change this behaviour, use "set unwind-on-terminating-exception off".
Evaluation of the expression containing the function (%s)
will be abandoned. The program being debugged was signaled while in a function called from GDB.
GDB has restored the context to what it was before the call.
To change this behaviour use "set unwindonsignal off".
Evaluation of the expression containing the function
(%s) will be abandoned. The program being debugged was signalled while in a function called from GDB.
GDB remains in the frame where the signal was received.
To change this behaviour use "set unwindonsignal on".
Evaluation of the expression containing the function
(%s) will be abandoned.
When the function is done executing, GDB will silently stop. This is the maximum number of characters GDB will ignore when trying to
synchronise with the remote system.  A value of -1 means that there is no
limit. (Note that these characters are printed out even though they are
ignored.) Unable to find dynamic linker breakpoint function.
GDB will be unable to debug shared library initialisers
and track explicitly loaded dynamic code. Unrecognised %d-bit floating-point type. Unrecognised DWARF opcode 0x%02x at %ld Unrecognised breakpoint/watchpoint type Unrecognised char '%c' in tracepoint definition, skipping rest Unrecognised cross-reference type `%c' Unrecognised escape character \%c in format string. Unrecognised format specifier '%c' in printf Unrecognised option '%s' to info macro command.  Try "help info macro". Unrecognised or ambiguous flag word: "%s". Unrecognised range check setting: "%s" Unrecognised storage class %d. Unrecognised tracepoint piece '%c', ignoring Unrecognised watch register style When this mode is on (which is the default), randomisation of the virtual
address space is disabled.  Standalone programs run with the randomisation
enabled by default on some platforms. `%s' has been optimised out, cannot use `%s' is optimised away and cannot be collected. auto-load: And canonicalised as "%s".
 cancelled field %s is nonexistent or has been optimised out internal error: string "%s" failed to be canonicalised mips_register_to_value: unrecognised case mips_value_to_register: unrecognised case missing null SO optimised out port 0x%04x, behaviour:  print_bp_stop_message: unrecognised enum value sect_index_data not initialised sect_index_rodata not initialised sect_index_text not initialised static field %s has been optimised out static field `%s' has been optimised out, cannot use too many initialisers unrecognised .gcc_compiled_longXX unrecognised DW_MACFINO opcode 0x%x unrecognised attribute: `%s' unrecognised bitness `%c' for probe `%s' unrecognised character type unrecognised flag '%c' unrecognised item "%s" in "qSupported" response unrecognised version `%d' in .debug_macro section value has been optimised out 