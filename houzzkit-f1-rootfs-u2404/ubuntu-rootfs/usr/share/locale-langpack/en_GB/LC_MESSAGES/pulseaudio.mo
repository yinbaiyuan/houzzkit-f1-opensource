��    #      4  /   L        9  	     C     J     W     c     v     �     �     �     �     �     �     �     	          1     E     Y     m     �     �     �     �  b   �     :     G     \     r     �    �     �  
   �     �     �  �  �  9  �     	#     #     !#     /#     D#     Z#     o#     �#     �#     �#     �#     �#     �#     �#     $     )$     ?$     U$     k$     �$     �$     �$  b   �$     *%     7%     L%     b%     |%    �%     �&  
   �&     �&     �&               "                                   !                                             	                            #         
                         %s [options]

COMMANDS:
  -h, --help                            Show this help
      --version                         Show version
      --dump-conf                       Dump default configuration
      --dump-modules                    Dump list of available modules
      --dump-resample-methods           Dump available resample methods
      --cleanup-shm                     Cleanup stale shared memory segments
      --start                           Start the daemon if it is not running
  -k  --kill                            Kill a running daemon
      --check                           Check for a running daemon (only returns exit code)

OPTIONS:
      --system[=BOOL]                   Run as system-wide instance
  -D, --daemonize[=BOOL]                Daemonize after startup
      --fail[=BOOL]                     Quit when startup fails
      --high-priority[=BOOL]            Try to set high nice level
                                        (only available as root, when SUID or
                                        with elevated RLIMIT_NICE)
      --realtime[=BOOL]                 Try to enable realtime scheduling
                                        (only available as root, when SUID or
                                        with elevated RLIMIT_RTPRIO)
      --disallow-module-loading[=BOOL]  Disallow user requested module
                                        loading/unloading after startup
      --disallow-exit[=BOOL]            Disallow user requested exit
      --exit-idle-time=SECS             Terminate the daemon when idle and this
                                        time passed
      --scache-idle-time=SECS           Unload autoloaded samples when idle and
                                        this time passed
      --log-level[=LEVEL]               Increase or set verbosity level
  -v  --verbose                         Increase the verbosity level
      --log-target={auto,syslog,stderr,file:PATH,newfile:PATH}
                                        Specify the log target
      --log-meta[=BOOL]                 Include code location in log messages
      --log-time[=BOOL]                 Include timestamps in log messages
      --log-backtrace=FRAMES            Include a backtrace in log messages
  -p, --dl-search-path=PATH             Set the search path for dynamic shared
                                        objects (plugins)
      --resample-method=METHOD          Use the specified resampling method
                                        (See --dump-resample-methods for
                                        possible values)
      --use-pid-file[=BOOL]             Create a PID file
      --no-cpu-limit[=BOOL]             Do not install CPU load limiter on
                                        platforms that support it.
      --disable-shm[=BOOL]              Disable shared memory support.
      --enable-memfd[=BOOL]             Enable memfd shared memory support.

STARTUP SCRIPT:
  -L, --load="MODULE ARGUMENTS"         Load the specified plugin module with
                                        the specified argument
  -F, --file=FILENAME                   Run the specified script
  -C                                    Open a command line on the running TTY
                                        after startup

  -n                                    Don't load default script file
 Analog Analog Input Analog Mono Analog Mono (Left) Analog Mono (Right) Analog Mono Duplex Analog Mono Output Analog Output Analog Stereo Analog Stereo Duplex Analog Surround 2.1 Analog Surround 3.0 Analog Surround 3.1 Analog Surround 4.0 Analog Surround 4.1 Analog Surround 5.0 Analog Surround 5.1 Analog Surround 6.0 Analog Surround 6.1 Analog Surround 7.0 Analog Surround 7.1 FFT based equalizer on %s Failed to initialize daemon due to errors while executing startup commands. Source of commands: %s Front Center Front Left-of-center Front Right-of-center General Purpose Equalizer Module initialization failed OK, so you are running PA in system mode. Please make sure that you actually do want to do that.
Please read http://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/WhatIsWrongWithSystemWide/ for an explanation why system mode is usually a bad idea. Rear Center Top Center Top Front Center Top Rear Center Project-Id-Version: pulseaudio
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2022-06-28 16:51+0000
Last-Translator: Stephan Woidowski <swoidowski@t-online.de>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Launchpad-Export-Date: 2025-01-30 17:57+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 %s [options]

COMMANDS:
  -h, --help                            Show this help
      --version                         Show version
      --dump-conf                       Dump default configuration
      --dump-modules                    Dump list of available modules
      --dump-resample-methods           Dump available resample methods
      --cleanup-shm                     Cleanup stale shared memory segments
      --start                           Start the daemon if it is not running
  -k  --kill                            Kill a running daemon
      --check                           Check for a running daemon (only returns exit code)

OPTIONS:
      --system[=BOOL]                   Run as system-wide instance
  -D, --daemonize[=BOOL]                Daemonise after startup
      --fail[=BOOL]                     Quit when startup fails
      --high-priority[=BOOL]            Try to set high nice level
                                        (only available as root, when SUID or
                                        with elevated RLIMIT_NICE)
      --realtime[=BOOL]                 Try to enable realtime scheduling
                                        (only available as root, when SUID or
                                        with elevated RLIMIT_RTPRIO)
      --disallow-module-loading[=BOOL]  Disallow user requested module
                                        loading/unloading after startup
      --disallow-exit[=BOOL]            Disallow user requested exit
      --exit-idle-time=SECS             Terminate the daemon when idle and this
                                        time passed
      --scache-idle-time=SECS           Unload autoloaded samples when idle and
                                        this time passed
      --log-level[=LEVEL]               Increase or set verbosity level
  -v  --verbose                         Increase the verbosity level
      --log-target={auto,syslog,stderr,file:PATH,newfile:PATH}
                                        Specify the log target
      --log-meta[=BOOL]                 Include code location in log messages
      --log-time[=BOOL]                 Include timestamps in log messages
      --log-backtrace=FRAMES            Include a backtrace in log messages
  -p, --dl-search-path=PATH             Set the search path for dynamic shared
                                        objects (plugins)
      --resample-method=METHOD          Use the specified resampling method
                                        (See --dump-resample-methods for
                                        possible values)
      --use-pid-file[=BOOL]             Create a PID file
      --no-cpu-limit[=BOOL]             Do not install CPU load limiter on
                                        platforms that support it.
      --disable-shm[=BOOL]              Disable shared memory support.
      --enable-memfd[=BOOL]             Enable memfd shared memory support.

STARTUP SCRIPT:
  -L, --load="MODULE ARGUMENTS"         Load the specified plugin module with
                                        the specified argument
  -F, --file=FILENAME                   Run the specified script
  -C                                    Open a command line on the running TTY
                                        after startup

  -n                                    Don't load default script file
 Analogue Analogue Input Analogue Mono Analogue Mono (Left) Analogue Mono (Right) Analogue Mono Duplex Analogue Mono Output Analogue Output Analogue Stereo Analogue Stereo Duplex Analogue Surround 2.1 Analogue Surround 3.0 Analogue Surround 3.1 Analogue Surround 4.0 Analogue Surround 4.1 Analogue Surround 5.0 Analogue Surround 5.1 Analogue Surround 6.0 Analogue Surround 6.1 Analogue Surround 7.0 Analogue Surround 7.1 FFT based equaliser on %s Failed to initialise daemon due to errors while executing startup commands. Source of commands: %s Front Centre Front Left-of-centre Front Right-of-centre General Purpose Equaliser Module initialisation failed OK, so you are running PA in system mode. Please make sure that you actually do want to do that.
Please read https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/WhatIsWrongWithSystemWide/ for an explanation of why system mode is usually a bad idea. Rear Centre Top Centre Top Front Centre Top Rear Centre 