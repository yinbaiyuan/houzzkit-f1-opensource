��    7      �  I   �      �  G   �  {   �  R   u  N   �  M     C   e  4   �  �   �  w   j  0   �  @     2   T  .   �  Q   �  R   	  �   [	  @   �	  >   .
  R   m
  =   �
  M   �
  �   L  Q   �  C   -  1   q     �     �     �     �  -        =     K     _  5   ~     �     �  ^   �  7   9  �  q  g     �   j  �  �  	   �  &   �  Q   �  U        i     �  ^   �       9        R  _   o  !   �    �  F     v   K  Q   �  K     [   `  G   �  4     �   9  p   �  1   R  A   �  3   �  /   �  V   *  �   �  �     F   �  J   	  K   T  <   �  \   �  �   :  S   �  7   #  2   [     �     �     �  $   �  4   �     0     =  *   Q  <   |  0   �     �  `   �  @   O   �  �   c   �"  �   �"  �  �#  	   F%  7   P%  M   �%  ]   �%     4&     Q&  x   m&     �&  D   �&  !   B'  b   d'  '   �'     $   !      2                   "                 .         *              	      '      /   1   (   3   ,   -   7       #   4            +       0                    )       
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
 Project-Id-Version: cpufrequtils 0.3
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2009-08-15 12:00+0900
Last-Translator: Mattia Dongili <malattia@gmail.com>
Language-Team: NONE
Language: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
           frequenza minima CPU   -  frequenza massima CPU  -  gestore
   -a, --affected-cpus  Determina quali CPU devono avere la frequenza
                       coordinata dal software *
   -c CPU, --cpu CPU        numero di CPU per la quale modificare le impostazioni
   -c CPU, --cpu CPU    Numero di CPU per la quale ottenere le informazioni
   -d FREQ, --min FREQ      la nuova frequenza minima che il gestore cpufreq può scegliere
   -d, --driver         Determina il modulo cpufreq del kernel in uso *
   -e, --debug          Mostra informazioni di debug
   -f FREQ, --freq FREQ     specifica la frequenza a cui impostare la CPU.
                           È necessario che il gestore userspace sia disponibile e caricato
   -f, --freq           Mostra la frequenza attuale della CPU secondo
                       il modulo cpufreq *
   -g GOV, --governor GOV   nuovo gestore cpufreq
   -g, --governors      Determina i gestori cpufreq disponibili *
   -h, --help               Stampa questa schermata
   -h, --help           Stampa questa schermata
   -l, --hwlimits       Determina le frequenze minima e massima possibili per la CPU *
   -m, --human          formatta l'output delle opzioni -f, -w, -s e -y in maniera
                       leggibile da un essere umano
   -o, --proc           Stampa le informazioni come se provenissero dalla
                       interfaccia cpufreq /proc/ presente nei kernel
                       2.4 ed i primi 2.6
   -p, --policy         Mostra il gestore cpufreq attualmente in uso *
   -r, --related            Modifica tutte le CPU coordinate dall'hardware
   -r, --related-cpus   Determina quali CPU operano alla stessa frequenza *
   -s, --stats          Mostra le statistiche se disponibili
   -u FREQ, --max FREQ      la nuova frequenza massima che il gestore cpufreq può scegliere
   -w, --hwfreq         Mostra la frequenza attuale della CPU leggendola
                       dall'hardware (disponibile solo per l'utente root) *
   -y, --latency        Determina la latenza massima durante i cambi di frequenza *
   CPU che è necessario siano coordinate dal software:    CPU che operano alla stessa frequenza hardware:    gestori disponibili:    frequenze disponibili:   statistiche cpufreq:   la frequenza attuale della CPU è    gestore attuale: la frequenza deve mantenersi tra    modulo %s
   limiti hardware:    latenza massima durante la transizione:    nessun modulo o modulo cpufreq sconosciuto per questa CPU
  (ottenuta da una chiamata diretta all'hardware)  e  Almeno una delle opzioni -f/--freq, -d/--min, -u/--max, e -g/--governor
deve essere specificata
 Impossibile determinare il numero di CPU (%s: %s), assumo sia 1
 Si sono verificati degli errori impostando i nuovi valori.
Alcuni errori comuni possono essere:
- Hai i necessari diritti di amministrazione? (super-user?)
- Il gestore che hai richiesto è disponibile e caricato?
- Stai provando ad impostare una politica di gestione non valida?
- Stai provando a impostare una specifica frequenza ma il gestore
  userspace non è disponibile, per esempio a causa dell'hardware
  che non supporta frequenze fisse o a causa del fatto che
  il gestore userspace non è caricato?
 Per le opzioni segnalate con *, omettere l'opzione -c o --cpu è come specificarla
con il valore 0
 Se non viene specificata nessuna opzione o viene specificata solo l'opzione -c, --cpu,
le informazioni di debug per cpufreq saranno utili ad esempio a riportare i bug.
 Note:
1. Omettere l'opzione -c o --cpu è equivalente a impostarlo a 0
2. l'opzione -f FREQ, --freq FREQ non può essere specificata con altre opzioni
   ad eccezione dell'opzione -c CPU o --cpu CPU
3. le FREQuenze possono essere specuficate in  Hz, kHz (default), MHz, GHz, or THz
   postponendo l'unità di misura al valore senza nessuno spazio fra loro
   (FREQuenza in kHz =^ Hz * 0.001 =^ MHz * 1000 =^ GHz * 1000000).
 Opzioni:
 Per favore, comunicare errori e malfunzionamenti a %s.
 L'opzione specificata a questo programma non può essere combinata con --cpu
  Il gestore "%s" può decidere quale velocità usare
                  in questo intervallo.
 Uso: cpufreq-info [opzioni]
 Uso: cpufreq-set [opzioni]
 Non è possibile specificare più di una volta l'opzione --cpu e/o
specificare più di un parametro di output specifico
 analisi della CPU %d:
 impossibile analizzare la CPU %d poiché non sembra essere presente
 opzione sconosciuta o non valida
 l'opzione -f/--freq non può venire combinata con i parametri
 -d/--min, -u/--max o -g/--governor
 CPU errata, sconosciuta o non gestita?
 