Þ    J      l  e   ¼      P     Q  ½   S  u                k   º  }   &	  [   ¤	      
     
     
     )
     7
     Q
  	   k
  	   u
     
     
     ­
     Á
  (   ß
               >     W     u       *   ¤  
   Ï     Ú  :   ö  9   1     k  "        ¨     À     Þ  %   ð  #        :     R     m       +        Ç  !   á  "     +   &     R     b  "   }           À     Ý     ø  %        1     E     Y  !   e  2     2   º  2   í        -   =  ;   k  /   §  	   ×     á     é     ù           2    K     ã     å  z   ~     ù       z   +  T   ¦  G   û     C     P     _     o               ¬     µ     ¾     Ù     ë     ý  ,        E     ]     t  *     *   »     æ  "   ü  
        *  E   C  E        Ï     ç       %        E  '   V  '   ~     ¦     Á     ß     ø  '        9     F     Y  #   i                ¶     Ò     â     ò       $        C     Y     o  !   }  .     .   Î  .   ý     ,  3   H  7   |  4   ´  	   é     ó     ú     	     !     =     E         3       0          @      8      D         (          
          B      .      -   +   #                 1           '         ?      )   !       /   :                        A       &       *           I   F                               C          %           2   G      $   7   H   >       <       J         	       5   ,   =   9   4   ;              6   "    
 
  cp0-names=ARCH           Print CP0 register names according to
                           specified architecture.
                           Default: based on binary being disassembled.
 
  fpr-names=ABI            Print FPR names according to specified ABI.
                           Default: numeric.
 
  gpr-names=ABI            Print GPR names according to  specified ABI.
                           Default: based on binary being disassembled.
 
  hwr-names=ARCH           Print HWR names according to specified 
			   architecture.
                           Default: based on binary being disassembled.
 
  reg-names=ABI            Print GPR and FPR names according to
                           specified ABI.
 
  reg-names=ARCH           Print CP0 register and HWR names according to
                           specified architecture.
 
The following ARM specific disassembler options are supported for use with
the -M switch:
 $<undefined> %02x		*unknown* %s: Error:  %s: Warning:  (DP) offset out of range. (SP) offset out of range. (unknown) *unknown* 21-bit offset out of range <function code %d> <illegal precision> <internal disassembler error> <internal error in opcode table: %s %s>
 <unknown register %d> Address 0x%s is out of bounds.
 Bad immediate expression Bad register in postincrement Bad register in preincrement Bad register name Don't know how to specify # dependency %s
 Hmmmm 0x%x Internal disassembler error Internal error:  bad sparc-opcode.h: "%s", %#.8lx, %#.8lx
 Internal error: bad sparc-opcode.h: "%s", %#.8lx, %#.8lx
 Label conflicts with `Rx' Label conflicts with register name Operand is not a symbol Syntax error: No trailing ')' Unknown error %d
 Unrecognised disassembler option: %s
 Unrecognised register name set: %s
 bad instruction `%.50s' bad instruction `%.50s...' branch operand unaligned branch to odd offset branch value not in range and to odd offset branch value out of range displacement value is not aligned displacement value is out of range don't know how to specify %% dependency %s
 illegal bitmask illegal use of parentheses immediate value cannot be register immediate value is out of range immediate value out of range invalid conditional option invalid mask field invalid register for stack adjustment jump hint unaligned junk at end of line missing `)' missing mnemonic in syntax string operand out of range (%ld not between %ld and %ld) operand out of range (%ld not between %ld and %lu) operand out of range (%lu not between %lu and %lu) register number must be even syntax error (expected char `%c', found `%c') syntax error (expected char `%c', found end of instruction) unable to change directory to "%s", errno = %s
 undefined unknown unknown	0x%04lx unknown constraint `%c' unrecognized form of instruction unrecognized instruction Project-Id-Version: opcodes 2.15.96
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2022-03-24 13:20+0000
Last-Translator: Meng Jie <Unknown>
Language-Team: Chinese (simplified) <i18n-zh@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 19:14+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
 
  cp0-names=ARCH           æ ¹æ®æå®çæ¶ææå° CP0 å¯å­å¨åã
                           é»è®¤ï¼æ ¹æ®è¢«åæ±ç¼çäºè¿å¶ä»£ç ã
 
  fpr-names=ABI            æ ¹æ®æå®ç ABI æå°æµ®ç¹å¯å­å¨åã
                           é»è®¤ï¼æ°å­ã
 
  gpr-names=ABI            æ ¹æ®æå®ç ABI æå°éç¨å¯å­å¨åã
                           é»è®¤ï¼æ ¹æ®è¢«åæ±ç¼çäºè¿å¶æä»¶ã
 
  hwr-names=ARCH           æ ¹æ®æå®çæ¶ææå° HWR å¯å­å¨åã
                           é»è®¤ï¼æ ¹æ®è¢«åæ±ç¼çäºè¿å¶ä»£ç ã
 
  reg-names=ABI            æ ¹æ®æå®ç ABI æå°éç¨å¯å­å¨åæµ®ç¹å¯å­
                           å¨åã
 
  reg-names=ARCH           æ ¹æ®æå®çæ¶ææå° CP0 å HWR å¯å­å¨åã
 
ä¸å ARM ç¹å®çåæ±ç¼å¨éé¡¹å¨ä½¿ç¨ -M å¼å³æ¶å¯ç¨ï¼
 $<æªå®ä¹> %02x		*æªç¥* %sï¼éè¯¯ï¼  %sï¼è­¦åï¼  (DP) åç§»éè¶ç (SP) åç§»éè¶çã (æªç¥) *æªç¥* 21ä½é¿çåç§»éè¶ç <å½æ°ä»£ç  %d> <éæ³çç²¾åº¦> <åæ±ç¼å¨åé¨éè¯¯> <æä½æ°è¡¨ä¸­åºç°åé¨éè¯¯ï¼%s %s>
 <æªç¥çå¯å­å¨ %d> å°å 0x%s è¶çã
 éè¯¯çç«å³æ°è¡¨è¾¾å¼ åç½®èªå¢ä¸­ä½¿ç¨äºéè¯¯çå¯å­å¨ åç½®èªå¢ä¸­ä½¿ç¨äºéè¯¯çå¯å­å¨ éè¯¯çå¯å­å¨å ä¸ç¥éå¦ä½æå® # ä¾èµ %s
 Hmmmm 0x%x åæ±ç¼å¨åé¨éè¯¯ åé¨éè¯¯ï¼éè¯¯ç sparc-opcode.hï¼â%sâï¼%#.8lxï¼%#.8lx
 åé¨éè¯¯ï¼éè¯¯ç sparc-opcode.hï¼â%sâï¼%#.8lxï¼%#.8lx
 æ å·ä¸âRxâå²çª æ å·ä¸å¯å­å¨åå²çª æä½æ°ä¸æ¯ä¸ä¸ªç¬¦å· è¯­æ³éè¯¯ï¼æ²¡æç»å°¾çâ)â æªç¥éè¯¯ %d
 æ æ³è¯å«çåæ±ç¼å¨éé¡¹ï¼%s
 æ æ³è¯å«çå¯å­å¨åç§°éï¼%s
 éè¯¯çæä»¤â%.50sâ éè¯¯çæä»¤â%.50s...â åæ¯æä½æ°æªå¯¹é½ è·³è½¬åç§»éä¸ºå¥æ° è·³è½¬è¶çä¸è·³è½¬åç§»éä¸ºå¥æ° è·³è½¬è¶ç åç§»å¼æªå¯¹é½ åç§»å¼è¶ç ä¸ç¥éå¦ä½æå® %% ä¾èµ %s
 éæ³çä½æ©ç  æ¬å·çä½¿ç¨éæ³ ç«å³æ°ä¸è½æ¯å¯å­å¨ ç«å³æ°è¶ç ç«å³æ°è¶ç æ æçæ¡ä»¶éé¡¹ æ æçæ©ç å­æ®µ ç¨äºè°æ´å æ çå¯å­å¨æ æ è·³è½¬æç¤ºæªå¯¹é½ è¡å°¾æåå¾å­ç¬¦ ç¼ºå°â)â è¯­æ³å­ç¬¦ä¸²ä¸­æ²¡æå©è®°ç¬¦ æä½æ°è¶ç(%ld ä¸å¨ %ld å %ld ä¹é´) æä½æ°è¶ç(%ld ä¸å¨ %ld å %lu ä¹é´) æä½æ°è¶ç(%lu ä¸å¨ %lu å %lu ä¹é´) å¯å­å¨æ°å¿é¡»æ¯å¶æ° è¯­æ³éè¯¯(éè¦å­ç¬¦â%câï¼å¾å°â%câ) è¯­æ³éè¯¯(éè¦å­ç¬¦â%câï¼å´å°è¾¾æä»¤å°¾) æ æ³å°å½åç®å½åæ¢è³â%sâï¼errno = %s
 æªå®ä¹ æªç¥ æªç¥	0x%04lx æªç¥ççº¦æâ%câ æ æ³è¯å«çæä»¤æ ¼å¼ æ æ³è¯å«çæä»¤ 