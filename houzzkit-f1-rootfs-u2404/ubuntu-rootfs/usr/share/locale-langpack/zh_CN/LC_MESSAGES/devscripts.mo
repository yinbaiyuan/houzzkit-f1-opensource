��          �   %   �      `    a     q     �     �     �  �   �     .     :     P  
   k     v  +   {     �     �     �  -   �  5   �     /     7     <     D     M     U  �   ^  �     >   �  �  �    {     �	     �	     �	     �	  u   �	     2
     >
     T
  
   j
     u
  +   |
     �
     �
     �
  *   �
  *   �
          !     (     /     6     =  �   D  �   �  ?   h                                                  	                                                        
                  $ annotate-output make
21:41:21 I: Started make
21:41:21 O: gcc -Wall program.c
21:43:18 E: program.c: Couldn't compile, and took me ages to find out
21:43:19 E: collect2: ld returned 1 exit status
21:43:19 E: make: *** [all] Error 1
21:43:19 I: Finished with exitcode 2
 ANNOTATE-OUTPUT ARCHPATH AUTHOR B<-h>, B<--help> B<annotate-output> will execute the specified program, while prepending every line with the current time and O for stdout and E for stderr. B<archpath> B<archpath> I<branch> B<archpath> was written by B<date>(1) BUGS Colin Watson E<lt>cjwatson@debian.orgE<gt>. DEBIAN DESCRIPTION Debian Utilities Display a help message and exit successfully. Do not send emails but print them to standard output. EXAMPLE NAME OPTIONS SEE ALSO SUPPORT SYNOPSIS Since stdout and stderr are processed in parallel, it can happen that some lines received on stdout will show up before later-printed stderr lines (and vice-versa). This program is community-supported (meaning: you'll need to fix it yourself).  Patches are however appreciated, as is any feedback (positive or negative). annotate-output - annotate program output with time and stream Project-Id-Version: devscripts
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2009-10-26 12:20+0000
Last-Translator: Hugh SH <Unknown>
Language-Team: Simplified Chinese <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 16:39+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 $ annotate-output make
21:41:21 I: Started make
21:41:21 O: gcc -Wall program.c
21:43:18 E: program.c: Couldn't compile, and took me ages to find out
21:43:19 E: collect2: ld returned 1 exit status
21:43:19 E: make: *** [all] Error 1
21:43:19 I: Finished with exitcode 2
 ANNOTATE-OUTPUT ARCHPATH 作者 B<-h>, B<--help> B<annotate-output> 会执行指定的程序并在每行上添加当前时间、O(标准输出) 和 E(标准错误)。 B<archpath> B<archpath> I<branch> B<archpath> 作者为 B<date>(1) 缺陷 Colin Watson E<lt>cjwatson@debian.orgE<gt>. DEBIAN 描述 Debian 组件 显示一条帮助信息并成功退出。 不发送邮件而是打印到标准输出 示例 名称 选项 参见 支持 概要 因为 stdout 和 stderr 是并行运行，所以可能有时会有几行 stdout 接收的信息显示在后来的 stderr 行里（反之亦然）。 本程序是由社区支持（这意味着：您需要自己修补软件缺陷）。欢迎打补丁和提供反馈（正面或负面的）。 annotate-output - 用时间和流信息对程序输出作注解 