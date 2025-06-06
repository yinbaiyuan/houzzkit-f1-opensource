��          \      �       �   0   �   �  �   ?   �  �  '      �  )   3   �$  �  %  4   �&  �  '  I   �,  �  <-    $6  �  @F  4   �J                                       %s: nameref variable self references not allowed Evaluate arithmetic expressions.
    
    Evaluate each ARG as an arithmetic expression.  Evaluation is done in
    fixed-width integers with no check for overflow, though division by 0
    is trapped and flagged as an error.  The following list of operators is
    grouped into levels of equal-precedence operators.  The levels are listed
    in order of decreasing precedence.
    
    	id++, id--	variable post-increment, post-decrement
    	++id, --id	variable pre-increment, pre-decrement
    	-, +		unary minus, plus
    	!, ~		logical and bitwise negation
    	**		exponentiation
    	*, /, %		multiplication, division, remainder
    	+, -		addition, subtraction
    	<<, >>		left and right bitwise shifts
    	<=, >=, <, >	comparison
    	==, !=		equality, inequality
    	&		bitwise AND
    	^		bitwise XOR
    	|		bitwise OR
    	&&		logical AND
    	||		logical OR
    	expr ? expr : expr
    			conditional operator
    	=, *=, /=, %=,
    	+=, -=, <<=, >>=,
    	&=, ^=, |=	assignment
    
    Shell variables are allowed as operands.  The name of the variable
    is replaced by its value (coerced to a fixed-width integer) within
    an expression.  The variable need not have its integer attribute
    turned on to be used in an expression.
    
    Operators are evaluated in order of precedence.  Sub-expressions in
    parentheses are evaluated first and may override the precedence
    rules above.
    
    Exit Status:
    If the last ARG evaluates to 0, let returns 1; let returns 0 otherwise. General help using GNU software: <http://www.gnu.org/gethelp/>
 Read a line from the standard input and split it into fields.
    
    Reads a single line from the standard input, or from file descriptor FD
    if the -u option is supplied.  The line is split into fields as with word
    splitting, and the first word is assigned to the first NAME, the second
    word to the second NAME, and so on, with any leftover words assigned to
    the last NAME.  Only the characters found in $IFS are recognized as word
    delimiters. By default, the backslash character escapes delimiter characters
    and newline.
    
    If no NAMEs are supplied, the line read is stored in the REPLY variable.
    
    Options:
      -a array	assign the words read to sequential indices of the array
    		variable ARRAY, starting at zero
      -d delim	continue until the first character of DELIM is read, rather
    		than newline
      -e	use Readline to obtain the line
      -i text	use TEXT as the initial text for Readline
      -n nchars	return after reading NCHARS characters rather than waiting
    		for a newline, but honor a delimiter if fewer than
    		NCHARS characters are read before the delimiter
      -N nchars	return only after reading exactly NCHARS characters, unless
    		EOF is encountered or read times out, ignoring any
    		delimiter
      -p prompt	output the string PROMPT without a trailing newline before
    		attempting to read
      -r	do not allow backslashes to escape any characters
      -s	do not echo input coming from a terminal
      -t timeout	time out and return failure if a complete line of
    		input is not read within TIMEOUT seconds.  The value of the
    		TMOUT variable is the default timeout.  TIMEOUT may be a
    		fractional number.  If TIMEOUT is 0, read returns
    		immediately, without trying to read any data, returning
    		success only if input is available on the specified
    		file descriptor.  The exit status is greater than 128
    		if the timeout is exceeded
      -u fd	read from file descriptor FD instead of the standard input
    
    Exit Status:
    The return code is zero, unless end-of-file is encountered, read times out
    (in which case it's greater than 128), a variable assignment error occurs,
    or an invalid file descriptor is supplied as the argument to -u. Set or unset values of shell options and positional parameters.
    
    Change the value of shell attributes and positional parameters, or
    display the names and values of shell variables.
    
    Options:
      -a  Mark variables which are modified or created for export.
      -b  Notify of job termination immediately.
      -e  Exit immediately if a command exits with a non-zero status.
      -f  Disable file name generation (globbing).
      -h  Remember the location of commands as they are looked up.
      -k  All assignment arguments are placed in the environment for a
          command, not just those that precede the command name.
      -m  Job control is enabled.
      -n  Read commands but do not execute them.
      -o option-name
          Set the variable corresponding to option-name:
              allexport    same as -a
              braceexpand  same as -B
              emacs        use an emacs-style line editing interface
              errexit      same as -e
              errtrace     same as -E
              functrace    same as -T
              hashall      same as -h
              histexpand   same as -H
              history      enable command history
              ignoreeof    the shell will not exit upon reading EOF
              interactive-comments
                           allow comments to appear in interactive commands
              keyword      same as -k
              monitor      same as -m
              noclobber    same as -C
              noexec       same as -n
              noglob       same as -f
              nolog        currently accepted but ignored
              notify       same as -b
              nounset      same as -u
              onecmd       same as -t
              physical     same as -P
              pipefail     the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
              posix        change the behavior of bash where the default
                           operation differs from the Posix standard to
                           match the standard
              privileged   same as -p
              verbose      same as -v
              vi           use a vi-style line editing interface
              xtrace       same as -x
      -p  Turned on whenever the real and effective user ids do not match.
          Disables processing of the $ENV file and importing of shell
          functions.  Turning this option off causes the effective uid and
          gid to be set to the real uid and gid.
      -t  Exit after reading and executing one command.
      -u  Treat unset variables as an error when substituting.
      -v  Print shell input lines as they are read.
      -x  Print commands and their arguments as they are executed.
      -B  the shell will perform brace expansion
      -C  If set, disallow existing regular files to be overwritten
          by redirection of output.
      -E  If set, the ERR trap is inherited by shell functions.
      -H  Enable ! style history substitution.  This flag is on
          by default when the shell is interactive.
      -P  If set, do not resolve symbolic links when executing commands
          such as cd which change the current directory.
      -T  If set, the DEBUG and RETURN traps are inherited by shell functions.
      --  Assign any remaining arguments to the positional parameters.
          If there are no remaining arguments, the positional parameters
          are unset.
      -   Assign any remaining arguments to the positional parameters.
          The -x and -v options are turned off.
    
    Using + rather than - causes these flags to be turned off.  The
    flags can also be used upon invocation of the shell.  The current
    set of flags may be found in $-.  The remaining n ARGs are positional
    parameters and are assigned, in order, to $1, $2, .. $n.  If no
    ARGs are given, all shell variables are printed.
    
    Exit Status:
    Returns success unless an invalid option is given. Write arguments to the standard output.
    
    Display the ARGs, separated by a single space character and followed by a
    newline, on the standard output.
    
    Options:
      -n	do not append a newline
      -e	enable interpretation of the following backslash escapes
      -E	explicitly suppress interpretation of backslash escapes
    
    `echo' interprets the following backslash-escaped characters:
      \a	alert (bell)
      \b	backspace
      \c	suppress further output
      \e	escape character
      \E	escape character
      \f	form feed
      \n	new line
      \r	carriage return
      \t	horizontal tab
      \v	vertical tab
      \\	backslash
      \0nnn	the character whose ASCII code is NNN (octal).  NNN can be
    		0 to 3 octal digits
      \xHH	the eight-bit character whose value is HH (hexadecimal).  HH
    		can be one or two hex digits
      \uHHHH	the Unicode character whose value is the hexadecimal value HHHH.
    		HHHH can be one to four hex digits.
      \UHHHHHHHH the Unicode character whose value is the hexadecimal value
    		HHHHHHHH. HHHHHHHH can be one to eight hex digits.
    
    Exit Status:
    Returns success unless a write error occurs. bash home page: <http://www.gnu.org/software/bash>
 Project-Id-Version: bash
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2022-09-07 23:12+0000
Last-Translator: Andi Chandler <Unknown>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Launchpad-Export-Date: 2025-01-30 16:29+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 %s: nameref variable self references are not allowed Evaluate arithmetic expressions.
    
    Evaluate each ARG as an arithmetic expression.  Evaluation is done in
    fixed-width integers with no check for overflow, though division by 0
    is trapped and flagged as an error.  The following list of operators is
    grouped into levels of equal-precedence operators.  The levels are listed
    in order of decreasing precedence.
    
    	id++, id--	variable post-increment, post-decrement
    	++id, --id	variable pre-increment, pre-decrement
    	-, +		unary minus, plus
    	!, ~		logical and bitwise negation
    	**		exponentiation
    	*, /, %		multiplication, division, remainder
    	+, -		addition, subtraction
    	<<, >>		left and right bitwise shifts
    	<=, >=, <, >	comparison
    	==, !=		equality, inequality
    	&		bitwise AND
    	^		bitwise XOR
    	|		bitwise OR
    	&&		logical AND
    	||		logical OR
    	expr ? expr : expr
    			conditional operator
    	=, *=, /=, %=,
    	+=, -=, <<=, >>=,
    	&=, ^=, |=	assignment
    
    Shell variables are allowed as operands.  The name of the variable
    is replaced by its value (coerced to a fixed-width integer) within
    an expression.  The variable need not have its integer attribute
    turned on to be used in an expression.
    
    Operators are evaluated in order of precedence.  Sub-expressions in
    brackets are evaluated first and may override the precedence
    rules above.
    
    Exit Status:
    If the last ARG evaluates to 0, let returns 1; let returns 0 otherwise. General help using GNU software: <https://www.gnu.org/help/gethelp.html>
 Read a line from the standard input and split it into fields.
    
    Reads a single line from the standard input, or from file descriptor FD
    if the -u option is supplied.  The line is split into fields as with word
    splitting, and the first word is assigned to the first NAME, the second
    word to the second NAME, and so on, with any leftover words assigned to
    the last NAME.  Only the characters found in $IFS are recognised as word
    delimiters. By default, the backslash character escapes delimiter characters
    and newline.
    
    If no NAMEs are supplied, the line read is stored in the REPLY variable.
    
    Options:
      -a array	assign the words read to sequential indices of the array
    		variable ARRAY, starting at zero
      -d delim	continue until the first character of DELIM is read, rather
    		than newline
      -e	use Readline to obtain the line
      -i text	use TEXT as the initial text for Readline
      -n nchars	return after reading NCHARS characters rather than waiting
    		for a newline, but honour a delimiter if fewer than
    		NCHARS characters are read before the delimiter
      -N nchars	return only after reading exactly NCHARS characters, unless
    		EOF is encountered or read times out, ignoring any
    		delimiter
      -p prompt	output the string PROMPT without a trailing newline before
    		attempting to read
      -r	do not allow backslashes to escape any characters
      -s	do not echo input coming from a terminal
      -t timeout	time out and return failure if a complete line of
    		input is not read within TIMEOUT seconds.  The value of the
    		TMOUT variable is the default timeout.  TIMEOUT may be a
    		fractional number.  If TIMEOUT is 0, read returns
    		immediately, without trying to read any data, returning
    		success only if input is available on the specified
    		file descriptor.  The exit status is greater than 128
    		if the timeout is exceeded
      -u fd	read from file descriptor FD instead of the standard input
    
    Exit Status:
    The return code is zero, unless end-of-file is encountered, read times out
    (in which case it's greater than 128), a variable assignment error occurs,
    or an invalid file descriptor is supplied as the argument to -u. Set or unset values of shell options and positional parameters.
    
    Change the value of shell attributes and positional parameters, or
    display the names and values of shell variables.
    
    Options:
      -a  Mark variables which are modified or created for export.
      -b  Notify of job termination immediately.
      -e  Exit immediately if a command exits with a non-zero status.
      -f  Disable file name generation (globbing).
      -h  Remember the location of commands as they are looked up.
      -k  All assignment arguments are placed in the environment for a
          command, not just those that precede the command name.
      -m  Job control is enabled.
      -n  Read commands but do not execute them.
      -o option-name
          Set the variable corresponding to option-name:
              allexport    same as -a
              braceexpand  same as -B
              emacs        use an emacs-style line editing interface
              errexit      same as -e
              errtrace     same as -E
              functrace    same as -T
              hashall      same as -h
              histexpand   same as -H
              history      enable command history
              ignoreeof    the shell will not exit upon reading EOF
              interactive-comments
                           allow comments to appear in interactive commands
              keyword      same as -k
              monitor      same as -m
              noclobber    same as -C
              noexec       same as -n
              noglob       same as -f
              nolog        currently accepted but ignored
              notify       same as -b
              nounset      same as -u
              onecmd       same as -t
              physical     same as -P
              pipefail     the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
              posix        change the behaviour of bash where the default
                           operation differs from the Posix standard to
                           match the standard
              privileged   same as -p
              verbose      same as -v
              vi           use a vi-style line editing interface
              xtrace       same as -x
      -p  Turned on whenever the real and effective user ids do not match.
          Disables processing of the $ENV file and importing of shell
          functions.  Turning this option off causes the effective uid and
          gid to be set to the real uid and gid.
      -t  Exit after reading and executing one command.
      -u  Treat unset variables as an error when substituting.
      -v  Print shell input lines as they are read.
      -x  Print commands and their arguments as they are executed.
      -B  the shell will perform brace expansion
      -C  If set, disallow existing regular files to be overwritten
          by redirection of output.
      -E  If set, the ERR trap is inherited by shell functions.
      -H  Enable ! style history substitution.  This flag is on
          by default when the shell is interactive.
      -P  If set, do not resolve symbolic links when executing commands
          such as cd which change the current directory.
      -T  If set, the DEBUG and RETURN traps are inherited by shell functions.
      --  Assign any remaining arguments to the positional parameters.
          If there are no remaining arguments, the positional parameters
          are unset.
      -   Assign any remaining arguments to the positional parameters.
          The -x and -v options are turned off.
    
    Using + rather than - causes these flags to be turned off.  The
    flags can also be used upon invocation of the shell.  The current
    set of flags may be found in $-.  The remaining n ARGs are positional
    parameters and are assigned, in order, to $1, $2, .. $n.  If no
    ARGs are given, all shell variables are printed.
    
    Exit Status:
    Returns success unless an invalid option is given. Write arguments to the standard output.
    
    Display the ARGs, separated by a single space character and followed by a
    newline, on the standard output.
    
    Options:
      -n	do not append a newline
      -e	enable interpretation of the following backslash escapes
      -E	explicitly suppress interpretation of backslash escapes
    
    `echo' interprets the following backslash-escaped characters:
      \a	alert (bell)
      \b	backspace
      \c	suppress further output
      \e	escape character
      \E	escape character
      \f	form feed
      \n	new line
      \r	carriage return
      \t	horizontal tab
      \v	vertical tab
      \[tab]backslash
      \0nnn	the character whose ASCII code is NNN (octal).  NNN can be
    		0 to 3 octal digits
      \xHH	the eight-bit character whose value is HH (hexadecimal).  HH
    		can be one or two hex digits
      \uHHHH	the Unicode character whose value is the hexadecimal value HHHH.
    		HHHH can be one to four hex digits.
      \UHHHHHHHH the Unicode character whose value is the hexadecimal value
    		HHHHHHHH. HHHHHHHH can be one to eight hex digits.
    
    Exit Status:
    Returns success unless a write error occurs. bash home page: <https://www.gnu.org/software/bash>
 