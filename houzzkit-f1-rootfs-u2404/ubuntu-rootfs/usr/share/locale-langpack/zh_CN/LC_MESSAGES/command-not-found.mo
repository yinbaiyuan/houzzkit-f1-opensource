��            )   �      �     �     �     �     �  .     1   @  :   r  ;   �  6   �  %      P   F      �     �     �  9   �     (  +   G  3   s  B   �  _   �  f   J     �  -   �  1   �     $  /   B  8   r  #   �     �  �  �  -   �	  +   �	     �	     �	  -   
  9   :
  1   t
  N   �
  7   �
  -   -  c   [     �     �     �  $        (  2   G  :   z  K   �  C     E   E     �     �     �     �  0   �  3   #  !   W     y                                              	         
                                                                                    command '%s' from deb %s%s   command '%s' from snap %s%s %prog [options] <command-name> %s: command not found Ask your administrator to install one of them. Command '%(command)s' is available in '%(place)s' Command '%(command)s' is available in the following places Command '%(command)s' not found, but can be installed with: Command '%s' not found, but there are %s similar ones. Command '%s' not found, did you mean: Could not find command-not-found database. Run 'sudo apt update' to populate it. Do you want to install it? (N/y) Exception information: Please ask your administrator. Please include the following information with the report: Python version: %d.%d.%d %s %d See 'snap info %s' for additional versions. See 'snap info <snapname>' for additional versions. Sorry, command-not-found has crashed! Please file a bug report at: The command could not be located because '%s' is not included in the PATH environment variable. This is most likely caused by the lack of administrative privileges associated with your user account. Try: %s <deb name> You will have to enable component called '%s' You will have to enable the component called '%s' command-not-found version: %s don't print '<command-name>: command not found' ignore local binaries and display the available packages use this path to locate data fields y Project-Id-Version: command-not-found
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2022-09-29 02:15+0000
Last-Translator: Harry Chen <Unknown>
Language-Team: Chinese (China) <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:50+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
   “%s” 命令来自 Debian 软件包 %s%s   “%s” 命令来自 Snap 软件包 %s%s %prog [选项] <命令> %s：未找到命令 咨询管理员以安装其中一个软件。 命令 “%(command)s” 可在 “%(place)s” 处找到 命令 “%(command)s” 可在以下位置找到 找不到命令 “%(command)s”，但可以通过以下软件包安装它： 找不到命令 “%s”，但有 %s 个相似命令。 找不到命令 “%s”，您的意思是： 没有找到 command-not-found 的数据库。请运行 “sudo apt update” 以增充数据库。 您要安装吗？(N/y) 额外信息： 请联系您的管理员。 请在报告中包含以下信息： Python 版本：%d.%d.%d %s %d 输入 “snap info %s” 以查看更多版本。 输入 “snap info <snapname>” 以查看更多版本。 抱歉，command-not-found 已经崩溃。请在以下地址报告错误： 由于 %s 不在 PATH 环境变量中，故无法找到该命令。 这很可能是由您的用户账户没有管理员权限造成的。 尝试 %s <deb name> 您必须启用 %s 组件 您必须启用 %s 组件 command-not-found 版本：%s 不输出 “<command-name>：未找到命令” 忽略本地二进制文件并显示可用软件包 使用该路径以定位数据域 是 