��    9      �  O   �      �     �     �       >   *  "   i  (   �     �  6   �     
  -   )  (   W     �  +   �  $   �  %   �  "     %   3  .   Y  -   �     �  0   �  >     2   @     s  "   �  B   �  
   �  ;   �  :   0	     k	     �	  (   �	  4   �	     �	  B   
  *   H
     s
     �
  &   �
  :   �
  &   �
  $    K   A  -   �     �  %   �     �           "     A     C     E     G     I     K     M  �  O     �          *  >   :     y  %   �     �  +   �     �  /     )   K     u  '   �  %   �  &   �  #         &      G  2   h     �  !   �  0   �          -     A  J   ]  	   �  8   �  <   �     (     B  !   Q  .   s     �  6   �  "   �          "  (   6  E   _  )   �  �   �  H   �  2        7  %   9     _  !   ~     �     �     �     �     �     �     �     �            #         8                     -   *                 .                           1   /       "              0   (      6         %   )      9      7      '          $   	                  3   
      ,       &   4                                 !       5      +           2    	%s		File: %s

 
-- Type space to continue -- 
 
Commands are:

   -1		check only first field in lines (delimiter = tabulator)
   -D		show available dictionaries
   -G		print only correct words or lines
   -H		HTML input file format
   -P password	set password for encrypted dictionaries
   -a		Ispell's pipe interface
   -d d[,d2,...]	use d (d2 etc.) dictionaries
   -h, --help	display this help and exit
   -i enc	input encoding
   -m 		analyze the words of the input text
   -n		nroff/troff input file format
   -p dict	set dict custom dictionary
   -t		TeX/LaTeX input file format
   -v, --version	print version number
   -vv		print Ispell compatible version number
 0-n	Replace with one of the suggested words.
 ?	Show this help screen.
 A	Accept the word for the rest of this session.
 AVAILABLE DICTIONARIES (path is not mandatory for -d option):
 Are you sure you want to throw away your changes?  Can't open %s.
 Cannot update personal dictionary. Check spelling of each FILE. Without FILE, check standard input.

 FORBIDDEN! Hunspell has been compiled without Ncurses user interface.
 I	Accept the word, and put it in your private dictionary.
 LOADED DICTIONARY:
%s
%s
 Line %d: %s ->  Model word (a similar dictionary word):  Model word must be in the dictionary. Press any key! New word (stem):  Q	Quit immediately. Asks for confirmation. Leaves file unchanged.
 R	Replace the misspelled word completely.
 Replace with:  SEARCH PATH:
%s
 Space	Accept the word this time only.
 U	Accept and add lowercase version to private dictionary.
 Usage: hunspell [OPTION]... [FILE]...
 Whenever a word is found that is not in the dictionary
it is printed on the first line of the screen.  If the dictionary
contains any similar words, they are listed with a number
next to each one.  You have the option of replacing the word
completely, or choosing one of the suggested words.
 X	Write the rest of this file, ignoring misspellings, and start next file.
 ^Z	Suspend program. Restart with fg command.
 a error - %s exceeds dictionary limit.
 error - iconv_open: %s -> %s
 error - iconv_open: UTF-8 -> %s
 error - missing HOME variable
 i q r s u x y Project-Id-Version: hunspell
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2009-10-29 10:04+0000
Last-Translator: snowdream <yanghui1986527@gmail.com>
Language-Team: Simplified Chinese <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:40+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 	%s		文件： %s

 
-- 空格键继续 -- 
 
命令是：

   -1		只检查一行的第一个区域 (定界符=制表符)
   -D		 显示可用词典
   -G		只显示正确的词或句子
   -H		HTML文件格式
   -P password	 为加密字典设置密码
   -a		Ispell的管道接口
   -d d[,d2,...]	 使用d (例如d2 等) 字典
   -h, --help	显示这个帮助并返回
   -i enc	 输入编码
   -m 		 分析输入文本中的单词
   -n		nroff/troff 输入格式文件
   -p dict	设定 dict 自定义词典
   -t		TeX/LaTeX 输入文件格式
   -v, --version	显示版本号
   -vv		显示Ispell的版本号
 0-n	数字键将替换为列表中的一个词。
 ?	显示这个帮助屏幕。
 A	键在这一段接受这个词
 可用词典（路径不强制使用-d选项）
 你确定要放弃修改吗？  无法打开 %s。
 不能够升级个人字典 检查每个文件的拼写。如果没有文件，检查标准输入。

 禁止！ Hunspell 已经用没有Ncurses用户界面编译完。
 I	键接受这个词，并把它加入到个人词典中。
 加载的字典：
%s
%s
 行 %d: %s ->  Model word (类似字典单词):  Model word必须在字典中。按任意键。 新单词（词干）：  Q	键询问是否退出，当前文件没有保存。
 R	 键完成替换错误的词。
 替换为:  搜索路径：
%s
 Space	空格键忽略这个词一次。
 U	键接受这个词，并把小写格式加入到个人词典中。
 用法: hunspell [选项]... [文件]...
 一个单词不管能否在字典中找到，
它都会在屏幕第一行打印出来。如果字典
包含任何类似的单词，它们将被依次列出来。
你完全可以选择替换这个单词，或者选择一个建议词。
 X	键忽略后面的内容，并保存文件，开始下一个文件。
 ^Z	Ctrl＋Z键暂停，用fg命令继续运行。
 a 错误 - %s 超出了字典限制。
 错误 - iconv_open: %s -> %s
 错误 - iconv_open: UTF-8 -> %s
 错误 - 缺少 HOME 变量
 i q r s u x y 