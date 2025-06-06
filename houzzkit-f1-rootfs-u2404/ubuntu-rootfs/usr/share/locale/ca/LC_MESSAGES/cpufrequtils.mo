��    7      �  I   �      �  G   �  {   �  R   u  N   �  M     C   e  4   �  �   �  w   j  0   �  @     2   T  .   �  Q   �  R   	  �   [	  @   �	  >   .
  R   m
  =   �
  M   �
  �   L  Q   �  C   -  1   q     �     �     �     �  -        =     K     _  5   ~     �     �  ^   �  7   9  �  q  g     �   j  �  �  	   �  &   �  Q   �  U        i     �  ^   �       9        R  _   o  !   �  +  �  U        s  [   �  V   O  a   �  P     8   Y  �   �  w   '  ?   �  J   �  3   *  2   ^  Z   �  e   �  �   R  A   �  G   .  b   v  I   �  b   #  �   �  `     I   m  5   �  #   �  $        6  '   U  /   }     �     �  $   �  9   �  #   9      ]   k   a   D   �   �  !  e   �"  �   M#  �  �#  	   �%  ,   �%  Q   �%  a   &  $   z&  "   �&  ^   �&     !'  B   8'  !   {'  e   �'  /   (     $   !      2                   "                 .         *              	      '      /   1   (   3   ,   -   7       #   4            +       0                    )       
             6         &                     %                           5                      minimum CPU frequency  -  maximum CPU frequency  -  governor
   -a, --affected-cpus  Determines which CPUs need to have their frequency
                       coordinated by software *
   -c CPU, --cpu CPU        number of CPU where cpufreq settings shall be modified
   -c CPU, --cpu CPU    CPU number which information shall be determined about
   -d FREQ, --min FREQ      new minimum CPU frequency the governor may select
   -d, --driver         Determines the used cpufreq kernel driver *
   -e, --debug          Prints out debug information
   -f FREQ, --freq FREQ     specific frequency to be set. Requires userspace
                           governor to be available and loaded
   -f, --freq           Get frequency the CPU currently runs at, according
                       to the cpufreq core *
   -g GOV, --governor GOV   new cpufreq governor
   -g, --governors      Determines available cpufreq governors *
   -h, --help               Prints out this screen
   -h, --help           Prints out this screen
   -l, --hwlimits       Determine the minimum and maximum CPU frequency allowed *
   -m, --human          human-readable output for the -f, -w, -s and -y parameters
   -o, --proc           Prints out information like provided by the /proc/cpufreq
                       interface in 2.4. and early 2.6. kernels
   -p, --policy         Gets the currently used cpufreq policy *
   -r, --related            Switches all hardware-related CPUs
   -r, --related-cpus   Determines which CPUs run at the same hardware frequency *
   -s, --stats          Shows cpufreq statistics if available
   -u FREQ, --max FREQ      new maximum CPU frequency the governor may select
   -w, --hwfreq         Get frequency the CPU currently runs at, by reading
                       it from hardware (only available to root) *
   -y, --latency        Determines the maximum latency on CPU frequency changes *
   CPUs which need to have their frequency coordinated by software:    CPUs which run at the same hardware frequency:    available cpufreq governors:    available frequency steps:    cpufreq stats:    current CPU frequency is    current policy: frequency should be within    driver: %s
   hardware limits:    maximum transition latency:    no or unknown cpufreq driver is active on this CPU
  (asserted by call to hardware)  and  At least one parameter out of -f/--freq, -d/--min, -u/--max, and
-g/--governor must be passed
 Couldn't count the number of CPUs (%s: %s), assuming 1
 Error setting new values. Common errors:
- Do you have proper administration rights? (super-user?)
- Is the governor you requested available and modprobed?
- Trying to set an invalid policy?
- Trying to set a specific frequency, but userspace governor is not available,
   for example because of hardware which cannot be set to a specific frequency
   or because the userspace governor isn't loaded?
 For the arguments marked with *, omitting the -c or --cpu argument is
equivalent to setting it to zero
 If no argument or only the -c, --cpu parameter is given, debug output about
cpufreq is printed which is useful e.g. for reporting bugs.
 Notes:
1. Omitting the -c or --cpu argument is equivalent to setting it to zero
2. The -f FREQ, --freq FREQ parameter cannot be combined with any other parameter
   except the -c CPU, --cpu CPU parameter
3. FREQuencies can be passed in Hz, kHz (default), MHz, GHz, or THz
   by postfixing the value with the wanted unit name, without any space
   (FREQuency in kHz =^ Hz * 0.001 =^ MHz * 1000 =^ GHz * 1000000).
 Options:
 Report errors and bugs to %s, please.
 The argument passed to this tool can't be combined with passing a --cpu argument
 The governor "%s" may decide which speed to use
                  within this range.
 Usage: cpufreq-info [options]
 Usage: cpufreq-set [options]
 You can't specify more than one --cpu parameter and/or
more than one output-specific argument
 analyzing CPU %d:
 couldn't analyze CPU %d as it doesn't seem to be present
 invalid or unknown argument
 the -f/--freq parameter cannot be combined with -d/--min, -u/--max or
-g/--governor parameters
 wrong, unknown or unhandled CPU?
 Project-Id-Version: debian Squeezy
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2011-03-05 21:10+0100
Last-Translator: Sergi Casbas <sergi.debian@qscsoft.net>
Language-Team: Catalan <>
Language: ca
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Plural-Forms: 
           mínima freqüència de CPU  -  màxima freqüència de CPU  -  governador
   -a, --affected-cpus  Determina quines CPUs necessiten coordinar la seva
                       freqüencial per programari *
   -c CPU, --cpu CPU        número de la CPU de la que s'en vol modificar la configuració
   -c CPU, --cpu CPU    número de la CPU de la que s'en vol determinar la informació
   -d FREQ, --min FREQ      nova freqüència mínima de la CPU que el governador pot seleccionar
   -d, --driver         Determina el controlador de cpufreq del nucli a emprar *
   -e, --debug          Mostra informació de depuració
   -f FREQ, --freq FREQ     especifica la freqüencia a establir. Requereix el governador
                           userspace disponible i carregat
   -f, --freq           Freqüència a la que funciona la CPU d'acord amb
                       el nucli del cpufreq *
   -g GOV, --governor GOV   Establir nou governador del cpufreq
   -g, --governors      Determina els governadors de cpufreq disponibles *
   -h, --help           Mostra aquesta informació
   -h, --help           Mostra aquesta informació
   -l, --hwlimits       Determina les freqüències mínima i màxima permeses de la UPC *
   -m, --human          sortida en format llegible per als humans per als paràmetres -f, -w, -s i -y
   -o, --proc           Mostra la informació proveïda per la interfície /proc/cpufreq
                       dels kernel 2.4. i els primerencs del 2.6
   -p, --policy         Retorna la directiva del cpufreq actual *
   -r, --related            Canvia el maquinari de les CPU relacionades
   -r, --related-cpus   Determina quines CPU0s funcionen a la mateixa freqüencial per maquinari *
   -s, --stats          Mostra els estadístiques disponibles del cpufreq
   -u FREQ, --max FREQ      nova freqüència màixima de la CPU que el governador pot seleccionar
   -w, --hwfreq         Freqüència actual de la CPU llegida per maquinari
                        (només disponible per al root) *
   -y, --latency        Determina la latència màxima en els canvis de freqüència de la CPU *
   CPUs que necessiten les seves freqüències coordinades per programari:   CPUs que necessiten anar a la mateixa freqüència:   governadors cpufreq disponibles:    salts de freqüència disponibles:   estadístiques del cpufreq:    la freqüència actual de la CPU és    la directiva de freqüència ha de ser entre     controlador:%s
   límits del maquinari:     màxima latència de transició:  Controlador cpufreq inactiu o desconegut per aquesta CPU
  (executat per crides al maquinari)  i  S'ha de facilitar com a mínim un dels següents paràmetres f/--freq,
 -d/--min, -u/--max, o g/--governor
 No es pot comptar el nombre total de CPUs (%s: %s), se n'assumeix 1
 Errors comuns al establir nous valors:
- Disposes dels permisos administratius adequats? (super-user?)
- Està el governador demanat disponible i provat al mod?
- S'està intentant establir una directiva invàlida?
- S'està intentant establir una freqüencia específica però el governador userspace no esta disponible,
   per exemple perquè el maquinari no pot ser establert en una freqüència específica 
   o perquè el governador userspace no està carregat?
 Per als arguments marcats amb un *, ometre l'argument -c o --cpu és
equivalent a establir-lo a zero
 Si no s'especifica argument o només s'especifica el paràmetre -c, --cpu, es mostrarà
la informació de depuració del cpufreq útil per exemple, per informar d'errors.
 Notes:
1. Ometre l'argument -c or --cpu és equivalent a establir-lo a zero
2. El paràmetre -f FREQ, --freq FREQ no pot ser combinat amb cap d'altre
   excepte el paràmetre -c CPU, --cpu CPU
3. Les FREQüències s'han de passar en Hz, kHz (defecte), MHz, GHz, or THz
   postfixant al valor desitjat en nom de la unitat sense cap espai
   (FREQuency in kHz =^ Hz * 0.001 =^ MHz * 1000 =^ GHz * 1000000).
 Opcions:
 Si us plau, Informi del errors i bugs a %s.
 Aquesta eina no pot combinar el paràmetre subministrat amb el paràmetre --cpu.
 EL governadors "%s" decidirà la freqüencial a fer servir
                  dins d'aquest rang.
 Forma d'ús: cpufreq-info [options]
 Forma d'ús: cpufreq-set [OPCIÓ]
 No es pot especificar més d'un paràmetre --cpu i/o més d'un
argument de sortida específic
 analitzant la CPU %d:
 No es pot analitzar la CPU %d ja que sembla que no està present.
 paràmetre invàlid o desconegut
 el paràmetre -f/--freq no és pot combinar amb els paràmetres -d/--,min
, -u/--max o -g/--governor
 CPU desconeguda, equivocada, o no manipulable?
 