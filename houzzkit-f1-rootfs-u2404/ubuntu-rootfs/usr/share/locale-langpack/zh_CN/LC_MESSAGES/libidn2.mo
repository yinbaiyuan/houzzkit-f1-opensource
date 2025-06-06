��    *      l  ;   �      �  �   �  �   �  �   >  c   �     A     Z  R  g  N   �  &   	  O   0     �  #   �  !   �  *   �  D   �  @   D	  %   �	  &   �	  &   �	  (   �	     "
     =
  6   I
     �
  (   �
  '   �
  4   �
  4     &   I  /   p  /   �  7   �  -     %   6  %   \  "   �     �  .   �  #   �  '        6    >  �   D  �     �   �  k   O     �     �  p  �  R   U  .   �  +   �       &        7  *   V  =   �  :   �  .   �     )     I  $   g     �     �  *   �     �  8   �  5      >   V  >   �  $   �  2   �  2   ,  9   _  6   �  A   �  !     &   4     [  *   q  %   �  H   �                     	   )                                 #          
                            !         '                  (                                         $          "          *             &   %          --usestd3asciirules   Enable STD3 ASCII rules
      --no-alabelroundtrip  Disable A-label roundtrip for lookups
      --debug               Print debugging information
      --quiet               Silent operation
   -T, --tr46t               Enable TR46 transitional processing
  -N, --tr46nt              Enable TR46 non-transitional processing
      --no-tr46             Disable TR46 processing
   -d, --decode              Decode (punycode) domain name
  -l, --lookup              Lookup domain name (default)
  -r, --register            Register label
   -h, --help                Print help and exit
  -V, --version             Print version and exit
 A-label roundtrip failed Charset: %s
 Command line interface to the Libidn2 implementation of IDNA2008.

All strings are expected to be encoded in the locale charset.

To process a string that starts with `-', for example `-foo', use `--'
to signal the end of parameters, as in `idn2 --quiet -- -foo'.

Mandatory arguments to long options are mandatory for short options too.
 Internationalized Domain Name (IDNA2008) convert STRINGS, or standard input.

 Try `%s --help' for more information.
 Type each input string on a line by itself, terminated by a newline character.
 Unknown error Usage: %s [OPTION]... [STRINGS]...
 could not convert string to UTF-8 could not determine locale encoding format domain label has character forbidden in non-transitional mode (TR46) domain label has character forbidden in transitional mode (TR46) domain label has forbidden dot (TR46) domain label longer than 63 characters domain name longer than 255 characters input A-label and U-label does not match input A-label is not valid input error libiconv required for non-UTF-8 character encoding: %s out of memory punycode conversion resulted in overflow punycode encoded data will be too large string contains a context-j character with null rule string contains a context-o character with null rule string contains a disallowed character string contains a forbidden context-j character string contains a forbidden context-o character string contains a forbidden leading combining character string contains forbidden two hyphens pattern string contains invalid punycode data string contains unassigned code point string could not be NFC normalized string encoding error string has forbidden bi-directional properties string is not in Unicode NFC format string start/ends with forbidden hyphen success Project-Id-Version: libidn2 2.3.3
Report-Msgid-Bugs-To: bug-libidn2@gnu.org
PO-Revision-Date: 2025-01-27 16:57+0000
Last-Translator: Boyuan Yang <073plan@gmail.com>
Language-Team: Chinese (simplified) <i18n-zh@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 18:58+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
X-Bugs: Report translation errors to the Language-Team address.
       --usestd3asciirules   启用 STD3 ASCII 规则
      --no-alabelroundtrip  查找时禁用 A-label roundtrip
      --debug               打印调试信息
      --quiet               处理时不显示信息
   -T, --tr46t               启用 TR46 过渡处理
  -N, --tr46nt              启用 TR46 非过渡处理
      --no-tr46             禁用 TR46 处理
   -d, --decode              解码（punycode）域名
  -l, --lookup              查找域名（默认）
  -r, --register            记录标签
   -h, --help               打印此帮助并退出
  -V, --version            打印程序版本并退出
 A-label roundtrip 失败 字符集：%s
 Libidn2 实现的 IDNA2008 的命令行界面。

所有的字符串都应以您所在区域的最合适的字符集进行编码。

如需处理一个以连字符（“-”）起始的字符串，例如“-foo”，请使用
“--”指示参数的结束位置，例如“idn2 --quiet -- -foo”。

长选项所必需的参数对于短选项来说也是必需的。
 国际化域名（IDNA2008）转换给定的字符串或标准输入的内容。

 尝试用‘%s --help’获取更多信息。
 输入时，每个字符串单占一行。
 未知错误 用法: %s [选项]... [字符串]...
 无法将字符串转为 UTF-8 无法确定区域（locale）编码格式 域标签含有非过渡模式（TR46）禁止使用的字符 域标签含有过渡模式（TR46）禁止使用的字符 域标签含有被禁止使用的点（TR46） 域标签长度超过 63 字符 域名长度超过 255 字符 输入 A-label 和 U-label 不匹配 输入 A-label 无效 输入错误 非 UTF-8 字符编码需要 libiconv：%s 内存耗尽 国际化域名编码（punycode）转换导致了溢出 国际化域名编码（punycode）数据将会过长 字符串包含带空规则（null rule）的 context-j 字符 字符串包含带空规则（null rule）的 context-o 字符 字符串包含了不允许的字符 字符串包含了禁止使用的 context-j 字符 字符串包含了禁止使用的 context-o 字符 字符串包含了禁止使用的起始部分合并字符 字符串包含了被禁止使用的双连字符模式 字符串包含无效的国际化域名编码（punycode）数据 字符串包含未分配的码点 无法对字符串进行 NFC 标准化 字符串编码错误 字符串含有禁止使用的双向属性 字符串未使用 Unicode NFC 格式 字符串的起始部分或终结束部分为被禁止使用的连字符 成功 