��            )   �      �     �  <   �  9   �  3   (     \  /   y     �     �     �  2   �  '   #     K     h  $   w     �  0   �  0   �          3     P     k     }  7  �  �  �  M   y     �     �     �  �  �      �  6   �  ,   �  "        <  !   U     w  $   �     �  -   �  '   �          -     9     T  #   i  #   �     �     �     �     �       q    �  �  c        x     �     �         
                      	                                                                                                           -- Press any key to continue -- An Ispell program was not given in the configuration file %s Are you sure you want to throw away your changes? (y/n):  Conversion of '%s' to character set '%s' failed: %s Error initialising libvoikko Error initializing character set conversion: %s File: %s Incomplete spell checker entry Missing argument for option %s Parse error in file "%s" on line %d, column %d: %s Parse error in file "%s" on line %d: %s Parse error in file "%s": %s Replace with:  Unable to open configuration file %s Unable to open file %s Unable to open file %s for reading a dictionary. Unable to open file %s for writing a dictionary. Unable to open temporary file Unable to set encoding to %s Unable to write to file %s Unknown option %s Unterminated quoted string Usage: %s [options] [file]...
Options: [FMNLVlfsaAtnhgbxBCPmSdpwWTv]

 -F <file>  Use given file as the configuration file.

The following flags are same for ispell:
 -v[v]      Print version number and exit.
 -M         One-line mini menu at the bottom of the screen.
 -N         No mini menu at the bottom of the screen.
 -L <num>   Number of context lines.
 -V         Use "cat -v" style for characters not in the 7-bit ANSI
            character set.
 -l         Only output a list of misspelled words.
 -f <file>  Specify the output file.
 -s         Issue SIGTSTP at every end of line.
 -a         Read commands.
 -A         Read commands and enable a command to include a file.
 -e[e1234]  Expand affixes.
 -c         Compress affixes.
 -D         Dump affix tables.
 -t         The input is in TeX format.
 -n         The input is in [nt]roff format.
 -h         The input is in sgml format.
 -b         Create backup files.
 -x         Do not create backup files.
 -B         Do not allow run-together words.
 -C         Allow run-together words.
 -P         Do not generate extra root/affix combinations.
 -m         Allow root/affix combinations that are not in dictionary.
 -S         Sort the list of guesses by probable correctness.
 -d <dict>  Specify an alternate dictionary file.
 -p <file>  Specify an alternate personal dictionary.
 -w <chars> Specify additional characters that can be part of a word.
 -W <len>   Consider words shorter than this always correct.
 -T <fmt>   Assume a given formatter type for all files.
 -r <cset>  Specify the character set of the input.
 Whenever an unrecognized word is found, it is printed on
a line on the screen. If there are suggested corrections
they are listed with a number next to each one. You have
the option of replacing the word completely, or choosing
one of the suggested words. Alternatively, you can ignore
this word, ignore all its occurrences or add it in the
personal dictionary.

Commands are:
 r       Replace the misspelled word completely.
 space   Accept the word this time only.
 a       Accept the word for the rest of this session.
 i       Accept the word, and put it in your personal dictionary.
 u       Accept and add lowercase version to personal dictionary.
 0-9     Replace with one of the suggested words.
 x       Write the rest of this file, ignoring misspellings,
         and start next file.
 q       Quit immediately.  Asks for confirmation.
         Leaves file unchanged.
 ^Z      Suspend program.
 ?       Show this help screen.
 [SP] <number> R)epl A)ccept I)nsert L)ookup U)ncap Q)uit e(X)it or ? for help \ at the end of a string aiuqxr yn Project-Id-Version: tmispell-voikko
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2008-04-01 11:03+0000
Last-Translator: TeliuTe <teliute@163.com>
Language-Team: Simplified Chinese <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:57+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 -- 请按下任意键以继续-- 一个 Ispell 程序没有在配置文件 %s 中给出 你确定你想放弃你的修改吗?(y/n):  %s到%s字符集的转换失败:%s libvoikko初始化出错 字符集转换初始化出错:%s 文件：%s 不完整的拼写检查程序引入 %s选项参数 在%s文件中第%d行第%d列语法错误:%s 在"%s"文件中第%d行语法错误:%s 在"%s"文件中语法错误:%s 替换为:  不能打开配制文件%s 不能打开%s文件 不能打开%s文件来读取字典 不能打开%s文件来写入字典 不能打开缓存文件 不能给%s设置编码 不能写入文件%s 未知选项 %s 未结束引证串 用法: %s [options] [file]...
选项: [FMNLVlfsaAtnhgbxBCPmSdpwWTv]

 -F <文件名>  用指定的文件作为配置文件

下面的标志与ispell相同:

 -v[v]      显示版本号然后退出.
 -M         在屏幕底部显示一行最小菜单.
 -N         屏幕底部不显示最小化菜单.
 -L <num>   行号.
 -V         用 "cat -v" 风格显示不是 7-bit ANSI 的字符
            字符集.
 -l         只输出一个错误单词的列表.
 -f <文件名>  指定输出文件.
 -s         在每行的结尾放 SIGTSTP .
 -a         读取命令.
 -A         读取命令并且允许命令中包含文件.
 -e[e1234]  扩展词缀.
 -c         压缩词缀.
 -D         重复词缀表.
 -t         输入是 TeX 格式.
 -n         输入是 [nt]roff 格式.
 -h         输入是 sgml 格式.
 -b         创建备份文件.
 -x         不创建备份文件.
 -B         不允许 run-together 合成词.
 -C         允许 run-together 合成词.
 -P         不产生额外的词根/词缀结合.
 -m         允许不在字典内的词根/词缀结合.
 -S         用正确率来排序最接近的词.
 -d <字典>  指定字典文件.
 -p <文件>  指定个人字典文件.
 -w <字符> 指定单词中存在的字符
 -W <字符长度>   比这个短的单词较正确.
 -T <格式>   给所有文件预定一个格式.
 -r <字符集>  指定输入的字符集.
 无论何时当一个不认识的单词被发现，它就会显示
一行在屏幕上，如果有建议的正确单词
它们会显示一个列表，每个单词前面有一个数字，
你可以选择替换这个词或者选择一个建议的词。
另外，你也可以忽略这个词，忽略全部这个词，
或者你可以把它添加到你的个人字典中。

命令是:
 r       完全替换这个错误的词.
 空格键   这次接受这个词.
 a       在这段里接受所有的这个词.
 i       接受这个词，并且把它添加到你的个人字典中.
 u       接受这个词并且把小写格式添加到个人词典中.
 0-9     替换成一个建议的词.
 x       保存文件，忽略其余的错误拼写,
         开始检查下一个文件.
 q       立即退出，退出前要确认，
         文件没有更改.
 ^Z      暂停程序.
 ?       显示帮助文件.
 [SP] <数字> R)替换 A)接受 I)插入 L)查找 U)打开 Q)终止 (X)返回 或者 ? 取得帮助 \在字符串结尾 aiuqxr yn 