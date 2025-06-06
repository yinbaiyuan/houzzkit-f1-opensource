��    7      �  I   �      �  G   �  {   �  R   u  N   �  M     C   e  4   �  �   �  w   j  0   �  @     2   T  .   �  Q   �  R   	  �   [	  @   �	  >   .
  R   m
  =   �
  M   �
  �   L  Q   �  C   -  1   q     �     �     �     �  -        =     K     _  5   ~     �     �  ^   �  7   9  �  q  g     �   j  �  �  	   �  &   �  Q   �  U        i     �  ^   �       9        R  _   o  !   �  �   �  R   �  }   <  b   �  Y     [   w  H   �  4     �   Q  �      5   �  G   �  '     (   -  T   V  X   �  �     G   �  K   �  U   ,  G   �  Y   �  �   $  X   �  D   +  3   p  '   �  '   �     �     
  2   )     \     j  "   �  @   �  $   �        ]      B   m   �  �   f   �"  �   #  �  �#  
   U%  )   `%  U   �%  Z   �%     ;&     Y&  p   v&     �&  O   �&  $   M'  f   r'  (   �'     $   !      2                   "                 .         *              	      '      /   1   (   3   ,   -   7       #   4            +       0                    )       
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
 Project-Id-Version: cpufrequtils 004
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2008-06-14 22:16-0400
Last-Translator: Claudio Eduardo <claudioeddy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
           frequência mínina do CPU  -  frequência máxima do CPU  -  regulador
   -a, --affected-cpus  Determina quais CPUs precisam ter suas frequências
                       coordenadas por software *
   -c CPU, --cpu CPU        número do CPU onde as configurações do cpufreq vão ser modificadas
   -c CPU, --cpu CPU    número do CPU sobre o qual as inforções devem ser determinadas
   -d FREQ, --min FREQ      nova frequência mínima do CPU que o regulador deve selecionar
   -d,  --driver         Determina o driver do kernel do cpufreq usado *
   -e, --debug          Mostra informação de debug
   -f FREQ, --freq FREQ     frequência específica para ser setada. Necessita que o regulador em
                           nível de usuário esteja disponível e carregado
   -f, --freq           Obtem a frequência na qual o CPU roda no momento, de acordo
                       com o núcleo do cpufreq *
   -g GOV, --governor GOV   novo regulador do cpufreq
   -g, --governors      Determina reguladores do cpufreq disponíveis *
  -h, --help           Mostra essa tela
  -h, --help           Imprime essa tela
   -l, --hwlimits       Determina a frequência mínima e máxima do CPU permitida *
   -m, --human          saída legível para humanos para os parâmetros -f, -w, -s e -y
   -o, --proc           Mostra informação do tipo provida pela interface /proc/cpufreq
                       em kernels 2.4. e mais recentes 2.6
 --p, --policy         Obtem a política do cpufreq em uso no momento *
   -r, --related            Modifica todos os CPUs relacionados ao hardware
   -r, --related-cpus   Determina quais CPUs rodam na mesma frequência de hardware *
   -s, --stats          Mostra estatísticas do cpufreq se disponíveis
   -u FREQ, --max FREQ      nova frequência máxima do CPU que o regulador deve escolher
   -w, --hwfreq         Obtem a frequência na qual o CPU está operando no momento,
                       através de leitura no hardware (disponível somente para root) *
   -y, --latency        Determina a latência máxima nas trocas de frequência do CPU *
   CPUs que precisam ter suas frequências coordenadas por software:    CPUs que rodam na mesma frequência de hardware:    reguladores do cpufreq disponíveis:    níveis de frequência disponíveis:    status do cpufreq:    frequência atual do CPU é    política de frequência atual deve estar entre    driver: %s
   limites do hardware:    maior latência de transição:    nenhum ou driver do cpufreq deconhecido está ativo nesse CPU
  (declarado por chamada ao hardware)  e  Pelo menos um parâmetro entre -f/--freq, -d/--min, -u/--max, e
-g/--governor deve ser usado
 Não foi possível contar o número de CPUs (%s: %s), assumindo 1
 Erro ao setar novos valores. Erros comuns:
- Você tem direitos administrativos necessários? (super-usuário?)
- O regulador que você requesitou está disponível e foi "modprobed"?
- Tentando setar uma política inválida?
- Tentando setar uma frequência específica, mas o regulador em nível de usuário não está disponível,
   por exemplo devido ao hardware que não pode ser setado pra uma frequência específica
   ou porque o regulador em nível de usuário não foi carregado?
 Para os argumentos marcados com *, omitir o argumento -c ou --cpu é
equivalente a setá-lo como zero
 Se nenhum argumento ou somente o parâmetro -c, --cpu é dado, informação de debug sobre
o cpufreq é mostrada, o que é útil por exemplo para reportar bugs.
 Notas:
1. Omitir o argumento -c or --cpu é equivalente a setá-lo como zero
2. O parâmetro -f FREQ, --freq FREQ não pode ser combinado com qualquer outro parâmetro
   exceto com o parâmetro -c CPU, --cpu CPU
3. FREQuências podem ser usadas em Hz, kHz (padrão), MHz, GHz, o THz
   colocando o nome desejado da unidade após o valor, sem qualquer espaço
   (FREQuência em kHz =^ Hz * 0.001 =^ MHz * 1000 =^ GHz * 1000000).
 Opções:
 Reporte erros e bugs para %s, por favor.
 O argumento usado pra essa ferramenta não pode ser combinado com um argumento --cpu
 O regulador "%s" deve decidir qual velocidade usar
                  dentro desse limite.
 Uso: cpufreq-info [opções]
 Uso: cpufreq-set [opções]
 Você não pode especificar mais do que um parâmetro --cpu e/ou
mais do que um argumento de saída específico
 analisando o CPU %d:
 não foi possível analisar o CPU % já que o mesmo parece não estar presente
 argumento inválido ou desconhecido
 o parâmetro -f/--freq não pode ser combinado com os parâmetros -d/--min, -u/--max ou
-g/--governor
 CPU errado, desconhecido ou inesperado?
 