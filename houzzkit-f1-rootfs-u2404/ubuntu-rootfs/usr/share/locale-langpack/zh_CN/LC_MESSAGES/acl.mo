��    4      �  G   \      x     y     �     �     �     �  )   �  )        ?  �   T  7     B   X  l  �  �   	  Z   �	  '   �	  '   
     8
  $   V
     {
     �
  &   �
  2   �
  3     /   @  /   p  =   �     �  %   �  2        R  $   j  &   �  +   �  '   �  ,   
  &   7  '   ^  *   �  +   �     �     �               1     H  &   f     �     �     �     �     �  �  �     �     �     �     �     �  )     )   7     a  �   w  3  )  1   ]  {  �  m     `   y  (   �  (        ,  !   L     n  "   �  &   �  7   �  =     0   D  6   u  ;   �     �  #     1   )     [  -   q  /   �  5   �  5     ;   ;  /   w  5   �  .   �  2        ?     ]     {     �     �     �  3   �  
          $   !     F     `                 	              
   4                                  ,                     0      %             )      2   *      #                    (       !              $   "         +                         &   .   -         3          /   1   '    	%s -B pathname...
 	%s -D pathname...
 	%s -R pathname...
 	%s -b acl dacl pathname...
 	%s -d dacl pathname...
 	%s -l pathname...	[not IRIX compatible]
 	%s -r pathname...	[not IRIX compatible]
 	%s acl pathname...
       --set=acl           set the ACL of file(s), replacing the current ACL
      --set-file=file     read ACL entries to set from file
      --mask              do recalculate the effective rights mask
   -R, --recursive         recurse into subdirectories
  -L, --logical           logical walk, follow symbolic links
  -P, --physical          physical walk, do not follow symbolic links
      --restore=file      restore ACLs (inverse of `getfacl -R')
      --test              test mode (ACLs are not modified)
   -d, --default           display the default access control list
   -m, --modify=acl        modify the current ACL(s) of file(s)
  -M, --modify-file=file  read ACL entries to modify from file
  -x, --remove=acl        remove entries from the ACL(s) of file(s)
  -X, --remove-file=file  read ACL entries to remove from file
  -b, --remove-all        remove all extended ACL entries
  -k, --remove-default    remove the default ACL
   -n, --no-mask           don't recalculate the effective rights mask
  -d, --default           operations apply to the default ACL
   -v, --version           print version and exit
  -h, --help              this help text
 %s %s -- get file access control lists
 %s %s -- set file access control lists
 %s: %s in line %d of file %s
 %s: %s in line %d of standard input
 %s: %s: %s in line %d
 %s: %s: Cannot change mode: %s
 %s: %s: Cannot change owner/group: %s
 %s: %s: Malformed access ACL `%s': %s at entry %d
 %s: %s: Malformed default ACL `%s': %s at entry %d
 %s: %s: No filename found in line %d, aborting
 %s: %s: Only directories can have default ACLs
 %s: No filename found in line %d of standard input, aborting
 %s: Option -%c incomplete
 %s: Option -%c: %s near character %d
 %s: Removing leading '/' from absolute path names
 %s: Standard input: %s
 %s: access ACL '%s': %s at entry %d
 %s: cannot get access ACL on '%s': %s
 %s: cannot get access ACL text on '%s': %s
 %s: cannot get default ACL on '%s': %s
 %s: cannot get default ACL text on '%s': %s
 %s: cannot set access acl on "%s": %s
 %s: cannot set default acl on "%s": %s
 %s: error removing access acl on "%s": %s
 %s: error removing default acl on "%s": %s
 %s: malloc failed: %s
 %s: opendir failed: %s
 Duplicate entries Invalid entry type Missing or wrong entry Multiple entries of same type Try `%s --help' for more information.
 Usage:
 Usage: %s %s
 Usage: %s [-%s] file ...
 preserving permissions for %s setting permissions for %s Project-Id-Version: acl
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2009-11-05 07:16+0000
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language-Team: Chinese (Simplified) <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:06+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 	%s -B 路径名...
 	%s -D 路径名...
 	%s -R 路径名...
 	%s -b acl dacl 路径名...
 	%s -d dacl 路径名...
 	%s -l 路径名...	[与 IRIX 不兼容]
 	%s -r 路径名...	[与 IRIX 不兼容]
 	%s acl 路径名...
       --set=acl 设定替换当前的文件访问控制列表
      --set-file=file 从文件中读取访问控制列表条目设定
      --mask 重新计算有效权限掩码
   -R, --recursive 递归操作子目录
  -L, --logical 依照系统逻辑，跟随符号链接
  -P, --physical 依照自然逻辑，不跟随符号链接
      --restore=file 恢复访问控制列表，和“getfacl -R”作用相反
      --test 测试模式，并不真正修改访问控制列表属性
   -d, --default   显示默认访问控制列表
   -m, --modify=acl 更改文件的访问控制列表
  -M, --modify-file=file 从文件读取访问控制列表条目更改
  -x, --remove=acl 根据文件中访问控制列表移除条目
  -X, --remove-file=file 从文件读取访问控制列表条目并删除
  -b, --remove-all 删除所有扩展访问控制列表条目
  -k, --remove-default 移除默认访问控制列表
   -n, --no-mask 不重新计算有效权限掩码
  -d, --default 应用到默认访问控制列表的操作
   -v, --version           显示版本并退出
  -h, --help              显示本帮助信息
 %s %s -- 获取文件访问控制列表
 %s %s -- 设定文件访问控制列表
 %s: %s 在 %d 行,于文件 %s
 %s: %s 在 %d 行于标准输出
 %s: %s: %s 于行 %d
 %s：%s：无法改变模式：%s
 %s: %s: 无法更改所有者/组: %s
 %s: %s: 异常的访问控制列表 "%s": %s 位于 %d
 %s: %s: 异常的默认访问控制列表 "%s": %s 位于 %d
 %s: %s: 在行 %d 没有发现文件名, 退出
 %s: %s: 只有目录有默认访问控制列表属性
 %s: 在标准输入的 %d 行没有发现文件名, 退出
 %s: 选项 -%c 尚未实现
 %s: 选项 -%c: %s 靠近字符 %d
 %s: 从绝对路径名尾部去除" / "字符。
 %s: 标准输入: %s
 %s: 访问控制列表 '%s': %s 于条目 %d
 %s: 无法获取访问控制列表于 '%s': %s
 %s: 无法获取访问控制列表文本于 '%s': %s
 %s: 无法获取默认访问控制列表于 '%s': %s
 %s: 无法获取默认访问控制列表文本于 '%s': %s
 %s: 无法设定访问控制列表于 "%s": %s
 %s: 无法设定默认访问控制列表于 "%s": %s
 %s：移除“%s”上的ACL出现错误：%s
 %s：移除“%s”上默认ACLU出现错误：%s
 %s：内存分配失败：%s
 %s：打开目录失败：%s
 重复条目 无效的条目类型 条目丢失或错误 出现同类型的多个条目 尝试 “%s --help” 命令获取更多信息。
 用法：
 用法: %s %s
 使用方法: %s  [-%s]  文件 ...
 正在保存 %s 的权限 设定 %s 的权限 