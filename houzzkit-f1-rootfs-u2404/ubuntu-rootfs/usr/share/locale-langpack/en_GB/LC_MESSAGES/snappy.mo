��    "      ,  /   <      �  K  �  ^  E  �  �  �   Q  9    �  X
  �  +  �  �  &  �  "   �  &     <   4  )   q     �  ,   �     �     �  #      a   $  _   �     �  �       �  4   �     �  5   �  4   2  &   g  C   �  3   �       f         t  �  �  I  b  ^  �  �    �   �  B  �  �  �  �  �!  �  L#  '  9%  !   a&  '   �&  <   �&  *   �&     '  ,   $'     Q'     c'  %   }'  f   �'  _   
(     j(  �   �(    )  6   0*     g*  7   �*  6   �*  '   �*  E   +  4   a+     �+  h   �+      ,                                      !                      	      
                                                "                                            
The ack command tries to add an assertion to the system assertion database.

The assertion may also be a newer revision of a pre-existing assertion that it
will replace.

To succeed the assertion must be valid, its signature verified with a known
public key and the assertion consistent with and its prerequisite in the
database.
 
The console-conf-start command starts synchronization with console-conf

This command is used by console-conf when it starts up. It delays refreshes if
there are none currently ongoing, and exits with a specific error code if there
are ongoing refreshes which console-conf should wait for before prompting the 
user to begin configuring the device.
 
The find command queries the store for available packages.

With the --private flag, which requires the user to be logged-in to the store
(see 'snap help login'), it instead searches for private snaps that the user
has developer access to, either directly or through the store's collaboration
feature.

A green check mark (given color and unicode support) after a publisher name
indicates that the publisher has been verified.
 
The list command displays a summary of snaps installed in the current system.

A green check mark (given color and unicode support) after a publisher name
indicates that the publisher has been verified.
 
The publisher of snap %q has indicated that they do not consider this revision
to be of production quality and that it is only meant for development or testing
at this point. As a consequence this snap will not refresh automatically and may
perform arbitrary system changes outside of the security sandbox snaps are
generally confined to, which may put your system at risk.

If you understand and want to proceed repeat the command including --devmode;
if instead you want to install the snap forcing it into strict confinement
repeat the command including --jailmode. 
The reboot command can used from allowed hooks to control the reboot behavior of the system.

Currently it can only be invoked from gadget install-device during UC20 install mode. After invoking it from install-device with --halt or --poweroff the device will not reboot into run mode after finishing install mode but will instead either halt or power off. From install-device the effect is therefore not immediate but delayed until the end of installation itself.
 
The reboot command reboots the system into a particular mode of the selected
recovery system.

When called without a system label and without a mode it will just
trigger a regular reboot.

When called without a label, the current system will be used for "run" mode. The
default recovery system will be used for "recover", "factory-reset" and
"install" modes.

Note that the "run" mode is only available for the current system.
 
The remodel command changes the model assertion of the device, either to a new
revision or a full new model.

In the process it applies any implied changes to the device: new required
snaps, new kernel or gadget etc.

Snaps and assertions are downloaded from the store unless they are provided as
local files specified by --snap and --assertion options. If using these
options, it is expected that all the needed snaps and assertions are provided
locally, otherwise the remodel will fail.
 
This revision of snap %q was published using classic confinement and thus may
perform arbitrary system changes outside of the security sandbox that snaps are
usually confined to, which may put your system at risk.

If you understand and want to proceed repeat the command including --classic.
 Allow snap %q to change %s to %q ? An email of a user on login.ubuntu.com Authorization is required to authenticate on the snap daemon Control the reboot behavior of the system Email address:  Image customizations specified as JSON file. Initialize device Name of key to delete Perform factory reset of the system Please be mindful pre-release channels may include features not completely tested or implemented. Please re-enter your Ubuntu One password to purchase %q from %q
for %s. Press ctrl-c to cancel. Print the version and exit Run the command under strace (useful for debugging). Extra strace options can be specified as well here. Pass --raw to strace early snap helpers. Select last change of given type (install, refresh, remove, try, auto-refresh, etc.). A question mark at the end of the type means to do nothing (instead of returning an error) if no change of the given type is found. Note the question mark could need protecting from the shell. Set id of snapshot to delete (see 'snap help saved') Set id of snapshot to export Set id of snapshot to restore (see 'snap help saved') Set id of snapshot to verify (see 'snap help saved') The login.ubuntu.com email to login as This dialog will close automatically after 5 minutes of inactivity. Use a little bit of color to highlight some things. email: invalid argument for snapshot set id: expected a non-negative integer argument (see 'snap help saved') snap %q has no updates available Project-Id-Version: snapd
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2024-09-14 13:31+0000
Last-Translator: Andi Chandler <Unknown>
Language-Team: English (United Kingdom) <en_GB@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=n != 1;
X-Launchpad-Export-Date: 2025-01-30 18:53+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
The ack command tries to add an assertion to the system assertion database.

The assertion may also be a newer revision of a pre-existing assertion that it
will replace.

To succeed, the assertion must be valid, its signature verified with a known
public key, and the assertion consistent with its prerequisite in the
database.
 
The console-conf-start command starts synchronisation with console-conf

This command is used by console-conf when it starts up. It delays refreshes if
there are none currently ongoing, and exits with a specific error code if there
are ongoing refreshes which console-conf should wait for before prompting the 
user to begin configuring the device.
 
The find command queries the store for available packages.

With the --private flag, which requires the user to be logged-in to the store
(see 'snap help login'), it instead searches for private snaps that the user
has developer access to, either directly or through the store's collaboration
feature.

A green check mark (given colour and unicode support) after a publisher name
indicates that the publisher has been verified.
 
The list command displays a summary of snaps installed in the current system.

A green check mark (given colour and unicode support) after a publisher name
indicates that the publisher has been verified.
 
The publisher of snap %q has indicated that they do not consider this revision
to be of production quality and that it is only meant for development or testing
at this point. As a consequence, this snap will not refresh automatically and may
perform arbitrary system changes outside of the security sandbox which snaps are
generally confined to, which may put your system at risk.

If you understand and want to proceed, repeat the command including --devmode;
if instead you want to install the snap forcing it into strict confinement,
repeat the command including --jailmode. 
The reboot command can used from allowed hooks to control the reboot behaviour of the system.

Currently it can only be invoked from gadget install-device during UC20 install mode. After invoking it from install-device with --halt or --poweroff the device will not reboot into run mode after finishing install mode but will instead either halt or power off. From install-device the effect is therefore not immediate but delayed until the end of installation itself.
 
The reboot command reboots the system into a particular mode of the selected
recovery system.

When called without a system label and without a mode, it will just
trigger a regular reboot.

When called without a label, the current system will be used for "run" mode. The
default recovery system will be used for "recover", "factory-reset" and
"install" modes.

Note that the "run" mode is only available for the current system.
 
The remodel command changes the model assertion of the device, either to a new
revision or a full new model.

In the process, it applies any implied changes to the device: new required
snaps, new kernel or gadget etc.

Snaps and assertions are downloaded from the store unless they are provided as
local files specified by --snap and --assertion options. If using these
options, it is expected that all the needed snaps and assertions are provided
locally, otherwise, the remodel will fail.
 
This revision of snap %q was published using classic confinement and thus may
perform arbitrary system changes outside of the security sandbox that snaps are
usually confined to, which may put your system at risk.

If you understand and want to proceed, repeat the command including --classic.
 Allow snap %q to change %s to %q? An e-mail of a user on login.ubuntu.com Authorisation is required to authenticate on the snap daemon Control the reboot behaviour of the system E-mail address:  Image customisations specified as JSON file. Initialise device Name of key to be deleted Perform a factory reset of the system Please be mindful that pre-release channels may include features not completely tested or implemented. Please re-enter your Ubuntu One password to purchase %q from %q
for %s. Press Ctrl-C to cancel. Print the version, and exit Run the command under strace (useful for debugging). Extra strace options can be specified here as well. Pass --raw to strace early snap helpers. Select last change of given type (install, refresh, remove, try, auto-refresh, etc.). A question mark at the end of the type means to do nothing (instead of returning an error) if no change of the given type is found. Note: the question mark could need protecting from the shell. Set ID of snapshot to delete (see >>snap help saved<<) Set ID of snapshot to export Set ID of snapshot to restore (see >>snap help saved<<) Set ID of snapshot to verify (see >>snap help saved<<) The login.ubuntu.com e-mail to login as This dialogue will close automatically after 5 minutes of inactivity. Use a little bit of colour to highlight some things. e-mail: invalid argument for snapshot set id: expected a non-negative integer argument (see >>snap help saved<<) snap %q has no available updates 