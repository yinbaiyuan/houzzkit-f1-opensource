��    �      t  �   �      �     �     �     �  0   �     )     7     H     Z     f     t     {     �     �     �     �  �  �     K  *   T          �     �     �     �     �     �     �  3     N   E     �  &   �  .   �     �     �     �  
     
     �     �  �  �   �  W   C  7   �     �  
   �     �  	   �               &     :     T     m     p     w     �     �  
   �     �     �     �  )   �     �               0     E  )   X  1   �     �     �     �     �     �  %   �          8     D     [     v     �     �     �     �     �     �     �          %     >     U     m  Q   �     �     �     
     *     F  .   f  )   �  �   �     Y     o     �     �  '   �  6   �  (     6   <  )   s     �     �     �     �     �     �       2   -  �   `  h     q   k     �  %   �          1     @  z   I  �   �  Q   �  C     B   H  G   �  F   �                 &      -      1      F     Y     ["     ^$     e$     u$  *   �$     �$     �$     �$     �$     �$     %     %     %     !%     .%     >%  E  E%  	   �&  &   �&     �&     �&     �&     �&     '     '     '     8'  0   W'  B   �'     �'  &   �'     �'     (     (     &(     -(     4(  �   @(  �  )  �   �*  Q   4+  E   �+     �+     �+  	   �+     �+     ,     ,      ,     0,     F,     S,     W,     ^,     k,  	   {,     �,     �,     �,     �,  3   �,  	   �,     �,     �,     -     '-  -   :-  -   h-     �-     �-     �-     �-  	   �-     �-     �-     �-     �-     .     !.     1.     A.     N.     d.     w.     �.     �.     �.     �.     �.     �.     /  E   /     a/     w/     �/     �/     �/  !   �/     �/  �   0     �0     �0     �0     �0     �0  *   1     11  *   P1     {1     �1     �1     �1     �1     �1     �1     2  6   $2  �   [2  a   �2  a   ?3  	   �3     �3     �3     �3     �3  l   �3  �   [4  <   5  9   P5  9   �5  ?   �5  ?   6     D6  
   H6  
   S6  
   ^6     i6  �  ~6  ~  68             M                     R   �   x   S   O   @   7   H   I       �   �       4      )   n   p                 Y   5   \   �   P   X   j   A       c   d       {               /   s   r                  ;                    }          T       J   8   ~      ^       i       D   F          N   b   v   6       u   *      e   0   (       L   '   B   
       	   �       U   K      3   m       <   l           1   :      >      Q   �   q      ?   V   2      �   #           .   �   f                 z   |   h           w   +              E   o       9      $       t   �   !   g       k   G   "   _              a       �         ,       ]   -   [   =   %           C      W   y                        �   Z   �   &           `    About Add a key binding All Chinese characters Another instance of this app is already running. Are you sure? Auto commit mode Auto commit mode: Auto select Auto wildcard Cancel Candidate list Chinese Chinese mode Chinese mode: Command Committing with the commit keys or with the mouse
always commits to the application. This option is about
“automatic” commits which may happen when
one just continues typing input without committing
manually. From time to time, “automatic” commits will
happen then.
“Direct” means such “automatic” commits go directly
into the application, “Normal” means they get committed
to preedit. Compose: Configure ibus-table “%(engine-name)s” Current key bindings: Debug level: Delete all learned data Details Direct Direct input Direct input letter width: Direct input punctuation width: Do you really want to restore all default settings? Do you really want to set the key bindings for all commands to their defaults? Edit Edit key bindings for command “%s” Edit the key bindings for the selected command English Full Half Horizontal Ibus Table Ibus-table is an input method framework for table-based input methods. Mostly it is used for Chinese input methods such as ZhengMa, WuBi, ErBi, CangJie, …. But some tables for other languages are available as well. If set to “Yes”, this does the following 4 things:
1) When typing “Return”, commit the 
   candidate + line-feed
2) When typing Tab, commit the candidate
3) When committing using a commit key, commit
   the candidate + " "
4) If typing the next character matches no candidates,
   commit the first candidate of the previous match.
   (Mostly needed for non-Chinese input methods like
   the Russian “translit”) If this is set to “single char”, only single
character candidates will be shown. If it is
set to “Phrase” candidates consisting of
several characters may be shown. If yes, a multi wildcard will be automatically
appended to the end of the input string. If yes, the color scheme for a dark theme will be used. Initial state Input mode Key bindings Key input Letter width Move key binding down Move key binding up Multi wildcard character: Multiple character match No Normal Onechar mode Online documentation: Orientation: Page size: Phrase Pinyin Pinyin mode Please press a key (or a key combination) Preferences Punctuation width Remove selected key binding Restore all defaults Set all to default Set default key bindings for all commands Set default key bindings for the selected command Set to default Settings Setup Show candidate list Simplified Chinese Simplified Chinese before traditional Simplified Chinese first Single Char Single character match Single wildcard character: Suggestion disabled Suggestion enabled Suggestion mode Switch Chinese mode Switch Input mode Switch autocommit mode Switch letter width Switch onechar mode Switch pinyin mode Switch punctuation width Switch suggestion mode Switch to Chinese input Switch to English input Switch to direct commit mode (automatic commits go directly into the application) Switch to direct input Switch to fullwidth letters Switch to fullwidth punctuation Switch to halfwidth letters Switch to halfwidth punctuation Switch to matching multiple characters at once Switch to matching only single characters Switch to normal commit mode (automatic commits go into the preedit instead of into the application. This enables automatic definitions of new shortcuts) Switch to pinyin mode Switch to suggestion mode Switch to table input Switch to table mode Switch to “All Chinese characters”. Switch to “Simplified Chinese before traditional”. Switch to “Simplified Chinese only”. Switch to “Traditional Chinese before simplified”. Switch to “Traditional Chinese only”. System default Table Table based input method Table input Table input letter width: Table input method for IBus. Table input punctuation width: The dialog will be closed when the key is released The maximum number of candidates in
one page of the lookup table. You can switch
pages in the lookup table using the page up/down
keys or the arrow up/down keys. The wildcard to match any single character.
Type RETURN or ENTER to confirm after changing the wildcard. The wildcard used to match any number of characters.
Type RETURN or ENTER to confirm after changing the wildcard. Traditional Chinese Traditional Chinese before simplified Traditional Chinese first Use dark theme Vertical When greater than 0, debug information may be printed to the log file and debug information may also be shown graphically. Whether candidate lists should be shown or hidden.
For Chinese input methods one usually wants the
candidate lists to be shown. But for some non-Chinese
input methods like the Russian “translit”, hiding the
candidate lists is better. Whether the lookup table showing the candidates
should be vertical or horizontal. Whether to use fullwidth or halfwidth
letters in direct input mode. Whether to use fullwidth or halfwidth
letters in table input mode. Whether to use fullwidth or halfwidth
punctuation in direct input mode. Whether to use fullwidth or halfwidth
punctuation in table input mode. Yes _Cancel _Close _OK ibus is not running. translator-credits “Simplified Chinese” shows only characters 
used in simplified Chinese. “Traditional Chinese”
shows only characters used in traditional Chinese.
“Simplified Chinese before traditional” shows all
characters but puts the simplified characters higher
up in the candidate list. “Traditional Chinese before
simplified” puts the traditional characters higher up
in the candidate list. “All characters” just shows all
matches without any particular filtering on traditional
versus simplified Chinese. Project-Id-Version: PACKAGE VERSION
Report-Msgid-Bugs-To: https://github.com/mike-fabian/ibus-table/issues
PO-Revision-Date: 2021-10-27 12:21+0000
Last-Translator: anonymous <Unknown>
Language-Team: Chinese (Simplified) <https://translate.fedoraproject.org/projects/ibus-table/app/zh_CN/>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 18:17+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
 关于 添加快捷键 全部汉字 此应用已有另一实例在运行中。 你确定吗？ 自动上屏模式 自动上屏模式： 自动选择： 自动通配符 取消 候选列表 中文 中文模式 中文模式： 命令 使用上屏键或鼠标上屏的内容总是传递给应用程序。
此选项是关于“自动”上屏的。当用户持续打字而
不手动上屏时，就可能发生“自动”上屏。
“直接”表示此“自动”上屏的内容直接传递给
应用程序，“普通”则表示内容会进入预编辑框。 组合： 配置 ibus-table“%(engine-name)s” 当前绑定的快捷键： 调试级别： 删除学习的数据 细节 直接 直接输入 直接输入的字母宽度： 直接输入的标点宽度： 你真的要将所有设置恢复为默认吗？ 你真的要将所有命令绑定的快捷键恢复为默认吗？ 编辑 编辑“%s”命令绑定的快捷键 编辑所选命令的快捷键 英文 全角 半角 横向 IBus 码表 Ibus-table 是个适用于码表输入法的输入法框架。通常用在中文输入法上，比如郑码、五笔、二笔、仓颉等等……但也有其他语言的码表使用此框架。 如果设为“是”，将执行以下 4 个规则：
1) 当按下“回车键”时，上屏候选字词并换行
2) 当按下“制表（Tab）键”时，上屏候选字词
3) 当使用上屏键时，上屏候选字词并附加空格
4) 如果打字输入的下个字符没有匹配的候选词时，
   上屏之前匹配候选词的第一个。（非中文输入法
   如俄语“转写”最需要） 如果此选项设为“单字”，只显示单个字符的候选列表。
如果设为“词组”，则包含多个字符的候选词也会显示。 如果设为是，则在输入字符串的末尾自动附加多匹配通配符。 如果选择“是”，将使用匹配深色主题的色彩方案。 初始状态 输入模式 快捷键 输入的键盘码 字母宽度 下移快捷键 上移快捷键 多匹配通配符： 多字匹配 否 普通 一字模式 在线文档： 方向： 页面大小： 词组 拼音 拼音模式 请按下一个键盘按键（或者按键组合） 首选项 标点宽度 移除所选快捷键 全部恢复为默认 全部设为默认 重置所有命令绑定的快捷键为默认 重置所选命令绑定的快捷键为默认 设为默认 设置 设置 显示候选列表 简体字 简体字先于繁体字 简体字优先 单字 单字匹配 单匹配通配符： 已禁用联想 已启用联想 联想模式 切换为中文模式 切换输入模式 切换自动上屏模式 切换字母宽度 切换一字模式 切换拼音模式 切换标点宽度 切换联想模式 切换为中文输入 切换为英文输入 切换为直接上屏模式（键盘打字直接进入应用程序） 切换为直接输入 切换为全角字母 切换为全角标点 切换为半角字母 切换为半角标点 切换为一次匹配多个字符 切换至仅匹配单字符 切换为普通上屏模式（键盘打字进入预编辑框，而不进入应用程序。使用此模式会启用新快捷键） 切换为拼音模式 切换为联想模式 切换为码表输入 切换为码表模式 切换为“全部汉字”。 切换为“简体字先于繁体字”。 切换为“仅简体字”。 切换为“繁体字先于简体字”。 切换为“仅繁体字”。 系统默认 码表 码表输入法 码表输入 码表输入的字母宽度： IBus 的码表输入法。 码表输入的标点宽度： 当按键被按下，这个对话框将会自动关闭 候选窗口里每个页面的候选项的最大数量。
你可以使用上/下翻页键或者上/下方向键来切换页面。 用于匹配任意单个字符的通配符。
更改通配符后按回车键或返回键确认。 用于匹配任意数量字符的通配符。
更改通配符后按回车键或返回键确认。 繁体字 繁体字先于简体字 繁体字优先 使用深色主题 纵向 当大于 0 时，调试信息可以打印到日志文件，并且调试信息也可以图形方式显示。 候选列表是要显示还是隐藏。
对于中文输入法通常需要显示候选列表。
但对于一些非中文输入法，如俄语“转写”，
隐藏候选列表更好。 显示候选字词的查找窗口应该横排还是竖排。 在直接输入模式下使用全角还是半角字母。 在码表输入模式下使用全角还是半角字母。 在直接输入模式下使用全角还是半角标点符号。 在码表输入模式下使用全角还是半角标点符号。 是 取消(_C) 关闭(_C) 确定(_O) IBus 没有运行。 黄鹏 <shawn.p.huang@gmail.com>
Pany <geekpany@gmail.com>
Tian Shixiong <tiansworld@fedoraproject.org>
Boyuan Yang <073plan@gmail.com>
Dingzhong Chen <wsxy162@gmail.com>
mozbugbox <mozbugbox@yahoo.com.au>

Launchpad Contributions:
  Boyuan Yang https://launchpad.net/~hosiet
  Liu Tao https://launchpad.net/~lyuutau
  Pany https://launchpad.net/~geekpany
  anonymous https://launchpad.net/~nore5ly
  wsxy162 https://launchpad.net/~wsxy162 “简体字”只显示简体中文中使用的字符。
“繁体字”只显示繁体中文中使用的字符。
“简体字先于繁体字”显示全部字符并将简体字放在候选列表上方。
“繁体字先于简体字”显示全部字符并将繁体字放在候选列表上方。
“全部汉字”显示全部匹配字符且不对繁体或简体字筛选排序。 