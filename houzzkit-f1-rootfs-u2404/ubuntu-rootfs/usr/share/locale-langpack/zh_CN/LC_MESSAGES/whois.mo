��    %      D  5   l      @     A  <   ]  >   �  �   �  )  �     �  �     A  �  �     �   �  �   �	     }
     �
  S   �
                1     M     c  "   y  1   �  
   �     �  C  �  F   2     y     �  &   �  =   �  T        Z      l  3   �  r   �  \   4  "   �  �  �  #   I  @   m  ?   �  �   �    �     �  �   �  4  �  �   �  �   �  �   b     
       O   3     �     �     �     �     �  #     +   %  
   Q     \  K  t  S   �  1     	   F  /   P  8   �  S   �       '   $  2   L  l     [   �  &   H     
   !                                                   %   	                     $                                                              "         #                         

Found a referral to %s.

 
Querying for the IPv4 endpoint %s of a 6to4 IPv6 address.

 
Querying for the IPv4 endpoint %s of a Teredo IPv6 address.

       -R, --rounds=NUMBER   use the specified NUMBER of rounds
      -P, --password-fd=NUM read the password from file descriptor NUM
                            instead of /dev/tty
      -s, --stdin           like --password-fd=0
       -h, --help            display this help and exit
      -V, --version         output version information and exit

If PASSWORD is missing then it is asked interactively.
If no SALT is specified, a random one is generated.
If TYPE is 'help', available methods are printed.

Report bugs to %s.
 %s/tcp: unknown service -B                     turn off object filtering (show email addresses)
-G                     turn off grouping of associated objects
-d                     return DNS reverse delegation objects too
 -R                     force to show local copy of the domain object even
                       if it contains referral
-a                     also search all the mirrored databases
-s SOURCE[,SOURCE]...  search the database mirrored from SOURCE
-g SOURCE:FIRST-LAST   find updates from SOURCE from serial FIRST to LAST
 -c                     find the smallest match containing a mnt-irt attribute
-x                     exact match
-b                     return brief IP address ranges with abuse contact
 -i ATTR[,ATTR]...      do an inverse look-up for specified ATTRibutes
-T TYPE[,TYPE]...      only look for objects of TYPE
-K                     only primary keys are returned
-r                     turn off recursive look-ups for contact information
 -t TYPE                request template for object of TYPE
-v TYPE                request verbose template for object of TYPE
-q [version|sources|types]  query specified server info
 Available methods:
 Cannot parse this line: %s Catastrophic error: disclaimer text has been changed.
Please upgrade this program.
 Host %s not found. Illegal salt character '%c'.
 Interrupted by signal %d... Invalid method '%s'.
 Invalid number '%s'.
 Method not supported by crypt(3).
 No whois server is known for this kind of object. Password:  Query string: "%s"

 These flags are supported by whois.ripe.net and some RIPE-like servers:
-l                     find the one level less specific match
-L                     find all levels less specific matches
-m                     find all one level more specific matches
-M                     find all levels of more specific matches
 This TLD has no whois server, but you can access the whois database at This TLD has no whois server. Timeout. Try '%s --help' for more information.
 Unknown AS number or IP network. Please upgrade this program. Usage: mkpasswd [OPTIONS]... [PASSWORD [SALT]]
Crypts the PASSWORD using crypt(3).

 Using server %s.
 Version %s.

Report bugs to %s.
 Warning: RIPE flags used with a traditional server. Wrong salt length: %d byte when %d <= n <= %d expected.
 Wrong salt length: %d bytes when %d <= n <= %d expected.
 Wrong salt length: %d byte when %d expected.
 Wrong salt length: %d bytes when %d expected.
 standard 56 bit DES-based crypt(3) Project-Id-Version: whois
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2019-07-19 18:30+0000
Last-Translator: Terence Ng <Unknown>
Language-Team: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
X-Launchpad-Export-Date: 2025-01-30 17:24+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
 

发现一个到 %s 的引用。

 
查询和一个6to4 IPv6 地址相对应的 IPv4 终端 %s。

 
查询一个Teredo IPv6 地址相对应的 IPv4 终端 %s。

       -R, --rounds=NUMBER 	使用指定的循环次数 NUMBER
      -P, --password-fd=NUM 	从文件描述符 NUM 中读取密码来
				替代从 /dev/tty 中获取密码
      -s, --stdin 		同 --password-fd=0
       -h, --help 		显示帮助信息并退出
      -V, --version 		输出版本信息并退出

如果密码不存在，将会要求输入密码。
如果未指定，将会随机生成一个SALT。
如果类型是 'help'，显示所有可用的方式。

请将BUGS提交给 %s。
 %s/tcp: 未知服务 -B                     关闭对象过滤（显示 email 地址）
-G                    关闭相关联对象的分组
-d                     返回 DNS 反解授权对象
 -R                     强制显示域对象的本地副本，即使
                         它包含引用
-a                     一并搜索所有的数据库镜像
-s SOURCE[,SOURCE]...   从 SOURCE 中搜索数据库镜像
-g SOURCE:FIRST-LAST   从串行的 FIRST 到 LAST 的 SOURCE 中查找更新
 -c                     寻找包含 mnt-irt 属性的最小匹配
-x                     精确匹配
-b                     return brief IP address ranges with abuse contact
 -i ATTR[,ATTR]...      对特定的属性（ ATTR ）进行逆向查询
-T TYPE[,TYPE]...      只寻找 TYPE 的对象
-K                      只返回主键
-r                      关闭联系信息的递归查询
 -t TYPE                 请求 TYPE 对象的模板
-v TYPE                 请求 TYPE 对象的详细模板
-q [version|sources|types]   询问制定服务器信息
 可用方式：
 不能分析该行：%s 严重错误: 声明(disclaimer)文本已经被改变。
请升级此程序。
 没有找到主机 %s。 非法的 salt 字符 '%c'。
 被信号 %d 中断... 无效方式 '%s'。
 无效的数字 '%s'。
 不被 crypt(3) 支持的方法。
 无针对此类对象的 whois 服务器。 密码：  查询字符串: "%s"

 这些标志是由 whois.ripe.net 和 RIPE-like 服务器支持的：
 -l                     寻找有更少具体匹配的一个级别
-L                     寻找所有更少具体匹配的级别
-m                   寻找有更加具体匹配的一个级别
-M                   寻找有更加具体的匹配的所有级别
 此顶级域名没有 whois 服务器，但您可在这里访问 whois 数据库： 此顶级域名没有对应的 whois 服务器。 超时。 尝试用 '%s --help' 获取更多的信息。
 未知的 AS 号码或 IP 地址。请升级此程序。 用法： mkpasswd [OPTIONS]... [PASSWORD [SALT]]
用 crypt(3) 加密 PASSWORD。

 使用服务器 %s。
 版本 %s。

将 bugs 提交到 %s。
 警告: 对传统服务器使用了 RIPE 标志。 错误的随机字符（salt） 长度: 当前为 %d 字节，预期长度范围为 %d <= n <= %d 字节。
 错误的随即字符 ( salt ) 长度：当前为 %d 字节，预期长度为 %d 字节。
 以标准56位DES为基础的 crypt(3) 