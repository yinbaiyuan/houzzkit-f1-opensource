��    F      L  a   |         o     ?   q  �   �  .   H  #   w     �  '   �     �     �            (   *     S  K   j     �     �  -   �     �      	  R   	     [	     i	  8   �	  M   �	  k   
  (   s
     �
     �
  u   �
     6     ;  X   @  @   �     �     �  ;     6   I  7   �  �   �  /   A  4   q  =   �  Y   �  �  >  )     7   ,     d  1   �  '   �  .   �  C       P     n  �   �     	       n   /     �  @   �     �  &        <     ?  '   Q     y  !   �     �  a   �     2  �  6  b   �  ?   L  �   �  (   $  !   M  %   o  1   �  	   �     �     �     �  '        ,  E   K     �     �  -   �     �     �  M   �     3     H  .   f  H   �  g   �  (   F     o      v  w   �       	     `      L   �     �     �  B   �  H   ?  3   �  �   �  -   j  =   �  6   �  S     �  a  (    !  5   )!     _!  :   }!  )   �!  1   �!  A   "    V"     i#  u   �#  
   �#      $  c   &$  !   �$  I   �$     �$  #   %     2%     6%  $   F%     k%      �%  #   �%  N   �%     &        3      &       A                    =                       /      @                   >       )                  '       2   <   +   :                 7   .   8   F      ;         ,      D   -   B          5       0                             *   1   "          C             9      $      6                  #   !   (   
      E      	   4   ?   %    
        --outdated		Merge in even outdated translations.
	--drop-old-templates	Drop entire outdated templates. 
  -o,  --owner=package		Set the package that owns the command.   -f,  --frontend		Specify debconf frontend to use.
  -p,  --priority		Specify minimum priority question to show.
       --terse			Enable terse mode.
 %s failed to preconfigure, with exit status %s %s is broken or not fully installed %s is fuzzy at byte %s: %s %s is fuzzy at byte %s: %s; dropping it %s is missing %s is missing; dropping %s %s is not installed %s is outdated %s is outdated; dropping whole template! %s must be run as root (Enter zero or more items separated by a comma followed by a space (', ').) Back Choices Config database not specified in config file. Configuring %s Debconf Debconf is not confident this error message was displayed, so it mailed it to you. Debconf on %s Debconf, running at %s Dialog frontend is incompatible with emacs shell buffers Dialog frontend requires a screen at least 13 lines tall and 31 columns wide. Dialog frontend will not work on a dumb terminal, an emacs shell buffer, or without a controlling terminal. Extracting templates from packages: %d%% Help Ignoring invalid priority "%s" Input value, "%s" not found in C choices! This should never happen. Perhaps the templates were incorrectly localized. More Next No usable dialog-like program is installed, so the dialog based frontend cannot be used. Note: Debconf is running in web mode. Go to http://localhost:%i/ Package configuration Preconfiguring packages ...
 Problem setting up the database defined by stanza %s of %s. TERM is not set, so the dialog frontend is not usable. Template #%s in %s does not contain a 'Template:' line
 Template #%s in %s has a duplicate field "%s" with new value "%s". Probably two templates are not properly separated by a lone newline.
 Template database not specified in config file. Template parse error near `%s', in stanza #%s of %s
 Term::ReadLine::GNU is incompatable with emacs shell buffers. The Sigils and Smileys options in the config file are no longer used. Please remove them. The editor-based debconf frontend presents you with one or more text files to edit. This is one such text file. If you are familiar with standard unix configuration files, this file will look familiar to you -- it contains comments interspersed with configuration items. Edit the file, changing any items as necessary, and then save it and exit. At that point, debconf will read the edited file, and use the values you entered to configure the system. This frontend requires a controlling tty. Unable to load Debconf::Element::%s. Failed because: %s Unable to start a frontend: %s Unknown template field '%s', in stanza #%s of %s
 Usage: debconf [options] command [args] Usage: debconf-communicate [options] [package] Usage: debconf-mergetemplate [options] [templates.ll ...] templates Usage: dpkg-reconfigure [options] packages
  -u,  --unseen-only		Show only not yet seen questions.
       --default-priority	Use default priority instead of low.
       --force			Force reconfiguration of broken packages.
       --no-reload		Do not reload templates. (Use with caution.) Valid priorities are: %s You are using the editor-based debconf frontend to configure your system. See the end of this document for detailed instructions. _Help apt-extracttemplates failed: %s debconf-mergetemplate: This utility is deprecated. You should switch to using po-debconf's po2debconf program. debconf: can't chmod: %s delaying package configuration, since apt-utils is not installed falling back to frontend: %s must specify some debs to preconfigure no none of the above please specify a package to reconfigure template parse error: %s unable to initialize frontend: %s unable to re-open stdin: %s warning: possible database corruption. Will attempt to repair by adding back missing question %s. yes Project-Id-Version: debconf 1.5.7
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2024-04-19 13:15+0000
Last-Translator: Xingyou Chen <Unknown>
Language-Team: Debian Chinese [GB] <debian-chinese-gb@lists.debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 16:38+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
 
        --outdated		合并过时的翻译。
	--drop-old-templates	取消整个过时的模板。 
  -o,  --owner=软件包		设定拥有该命令的软件包。   -f,  --frontend		指定 debconf 前端界面。
  -p,  --priority		指定要显示的问题的最优先级。
       --terse			开启简要模式。
 预设定 %s 失败，退出状态为 %s %s 已被损坏或未完成安装 %s 是不正确的，位置在 %s: %s %s 是不正确的，位置在 %s: %s；放弃之 没有 %s 没有 %s；弃用 %s %s 未安装 %s 已经过时 %s 已经过时；弃用整个模板！ %s 必须以 root 身份执行 (输入零个或以逗号加空格(“, ”)分隔的多个项目)。 返回 选择 配置文件中没有指定配置数据库。 正在设定 %s Debconf Debconf 不确定此错误信息有没有显示，所以它被寄给了您。 Debconf 运行于 %s Debconf，正在 %s 上运行 对话框界面与 Emacs shell 缓存不兼容 对话框界面要求屏幕画面必须为至少 13 行高及 31 列宽. 对话框界面将不能在哑终端上运行，例如 Emacs shell 缓存，或者没有控制终端。 正在从软件包中解出模板：%d%% 帮助 忽略无效的优先级“%s” 没有在 C 选择中找到输入值“%s”！这是不应该发生的，可能是因为模板被错误的本地化。 更多 下一步 没有安装任何可用的对话框类程序，所以无法使用基于此种形式的界面。 注意：Debconf 正在以 web 模式执行。请浏览 http://localhost:%i/ 软件包设置 正在预设定软件包 ...
 在设定由 %2$s 第 %1$s 部分所定义的数据库时出错。 系统未设定 TERM 环境变量, 所以对话框界面将不可使用. %2$s 中第 %1$s 模板未包含“Template:”行
 %2$s 中的第 %1$s 模板有一个重复字段“%3$s”，其中新值为“%4$s”。造成问题的原因可能是两个模板没有以正确地用换行符分隔开。
 配置文件中没有指定模板数据库。 %3$s 中第 %2$s 部分“%1$s”附近的模板解析出错
 Term::ReadLine::GNU 与 Emacs shell 缓存不兼容。 配置文件中的 Sigils 和 Smileys 选项已不再被使用，请删除他们。 基于编辑器形式的 debconf 会向您展示一个或多个的待修改文件。这是其中一个文件。如果您比较了解标准的 Unix 设置文件，这个文件对您来说将会是很熟悉的 -- 它包含一些注释和设定项目。请编辑此文件，更改任何必要的项目，然后保存并离开。同时，debconf 会读取已修改的文件，并使用您输入的值来配置系统。 这个界面要求直接操作的 tty。 不能载入 Debconf::Element::%s，失败原因：%s 无法开启前端界面：%s %3$s 中第 %2$s 部分有未知的模板字段“%1$s”
 用法：debconf [选项] 命令 [参数] 用法：debconf-communicate [选项] [软件包] 用法：debconf-mergetemplate [选项] [templates.ll ...] 模板 用法: dpkg-reconfigure [选项] 包1 包2 ...
  -u,  --unseen-only		只显示尚未查看的问题。
       --default-priority	使用默认问题优先级而不是低。
       --force			强制配置损坏的包。
       --no-reload		不要重新加载模版 (小心)。 有效的优先级为：%s 您正在使用基于编辑器形式的 debconf 界面设定系统。请留意本文件末尾有关的详细教程。 帮助(_H) apt-extracttemplates 失败：%s debconf-mergetemplate：本工具已被废弃。您应该改用 po-debconf 的 po2debconf 程序。 debconf：无法改变权限：%s 因为并未安装 apt-utils，所以软件包的设定过程将被推迟 返回前端界面：%s 必须指定要预设定的 deb 包 否 以上都不是 请指定要重新设定的软件包 模板解读错误: %s 无法初始化前端界面：%s 重新开启标准输入失败：%s 警告：数据库可能已被损坏。将会尝试修复缺失的项目 %s。 是 