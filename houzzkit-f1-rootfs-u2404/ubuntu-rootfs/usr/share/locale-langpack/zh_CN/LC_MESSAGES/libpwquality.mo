��    4      �  G   \      x  L   y     �     �     �  0     *   7  
   b     m     {  $   �     �  %   �  B   �  #   6  !   Z      |     �     �  #   �  2   �  5   1  *   g  5   �  ?   �  5     C   >  N   �  A   �  0   	  $   D	  /   i	  9   �	  /   �	  @   
  I   D
  <   �
  G   �
  +     6   ?  '   v     �  $   �  +   �  '        4  *   N     y     �     �     �  J   �  �    >        C     Y     i  2   �  !   �     �     �     �  !        (     8  0   Q     �     �     �     �     �       *   0  &   [     �  &   �  2   �  &   �  .     2   M  /   �  $   �     �  !   �  -     !   A  '   c  -   �  '   �  0   �       $   1     V     r     �     �     �     �     �               *     E  E   Z                          +      3              "   0   &                  $   *                                 
               2   '       (             !             )      	      /             1   .   4   %   ,       -                            #              The command reads the password to be scored from the standard input.
 BAD PASSWORD: %s Bad integer value Bad integer value of setting Cannot obtain random numbers from the RNG device Could not obtain the password to be scored Error: %s
 Fatal failure Memory allocation error Memory allocation error when setting No password supplied Opening the configuration file failed Password generation failed - required entropy too low for settings Password quality check failed:
 %s
 Setting %s is not of integer type Setting %s is not of string type Setting is not of integer type Setting is not of string type The configuration file is malformed The password contains forbidden words in some form The password contains less than %ld character classes The password contains less than %ld digits The password contains less than %ld lowercase letters The password contains less than %ld non-alphanumeric characters The password contains less than %ld uppercase letters The password contains monotonic sequence longer than %ld characters The password contains more than %ld characters of the same class consecutively The password contains more than %ld same characters consecutively The password contains the user name in some form The password contains too few digits The password contains too few lowercase letters The password contains too few non-alphanumeric characters The password contains too few uppercase letters The password contains too long of a monotonic character sequence The password contains too many characters of the same class consecutively The password contains too many same characters consecutively The password contains words from the real name of the user in some form The password differs with case changes only The password does not contain enough character classes The password fails the dictionary check The password is a palindrome The password is just rotated old one The password is shorter than %ld characters The password is the same as the old one The password is too short The password is too similar to the old one Unknown error Unknown setting Usage: %s <entropy-bits>
 Usage: %s [user]
 Warning: Value %ld is outside of the allowed entropy range, adjusting it.
 Project-Id-Version: PACKAGE VERSION
Report-Msgid-Bugs-To: http://fedorahosted.org/libpwquality
PO-Revision-Date: 2022-12-16 07:12+0000
Last-Translator: ljanda <Unknown>
Language-Team: Chinese (Simplified) <https://translate.fedoraproject.org/projects/libpwquality/app/zh_CN/>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 18:40+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
        命令通过标准输入读取需要评分的密码。
 无效的密码： %s 坏的整数值 错误的整数设置值 无法从 RNG 随机数生成设备获得随机数 无法获得需要评分的密码 错误: %s
 致命的错误 内存分配错误 设置时发生内存分配错误 密码未提供 打开配置文件失败 密码生成失败 - 未达到设置所需的熵 密码质量检查失败：
%s
 设置 %s 并非整数类型 设置 %s 并非字符串类型 设置并非整数类型 设置并非字符串类型 配置文件格式不正确 密码包含了某种形式的禁用单词 密码包含少于 %ld 的字符类型 密码少于 %ld 的位数 密码包含少于 %ld 的小写字母 密码包含少于 %ld 的非字母或数字字符 密码包含少于 %ld 的大写字母 密码包含超过%ld 个字符的单调序列 密码包含了超过 %ld 的同类型连续字符 密码包含了超过 %ld 的相同连续字符 密码包含用户名在某些地方 密码包含的位数太短 密码包含的小写字母太少 密码包含的非字母或数字字符太少 密码包含的大写字母太少 密码包含过长的单调字符序列 密码包含了过多的同类型连续字符 密码包含了太多相同连续字符 密码包含了某种形式的用户真实名称 密码仅包含大小写变更 密码未包含足够的字符类型 密码未通过字典检查 密码是一个回文 密码仅是旧密码的反转 密码少于 %ld 个字符 这个密码和原来的相同 密码太短了 密码与原来的太相似 未知的错误 未知设置 用法: %s <entropy-bits>
 用法： %s [user]
 警告： %ld 的值在允许的熵范围之外，需要调整它。
 