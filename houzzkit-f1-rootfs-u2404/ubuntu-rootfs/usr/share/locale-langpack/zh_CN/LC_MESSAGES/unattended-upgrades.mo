��    9      �  O   �      �     �                *  4   @     u  "   �  "   �  '   �  �     �   �  8   B     {  /   �     �     �     �  =     ,   L  j   y  N   �  '   3	  *   [	     �	  %   �	     �	  $   �	  !   
  1   (
  0   Z
     �
  "   �
  /   �
     �
  #     ,   5  '   b  #   �  )   �  '   �  >         ?  R   ]     �  X   �  .   #     R  L   j  +   �     �     �            =   3     q     �  �  �     d     }     �     �  .   �  (   �       *   7     b  p   �  �   �  4   �     �  %   �     �          -  8   C  +   |  `   �  ]   	     g     �  %   �     �     �               ;     [     y     �  /   �     �  &   �  *        H  !   d  6   �  "   �  <   �       E   ;     �  E   �  6   �       D   +  -   p     �     �     �     �  9   �     .     A     "       6   *   &   .   9   4         -       #   +            ,             8          %      	   !   (                        $          )                                   3           7   2      
      /                                        '   1                      5   0       All upgrades installed Allowed origins are: %s An error occurred An error occurred: %s Apt returned an error thus shutdown mode is disabled Apt returned an error, exiting Auto-removing the packages failed! Cache has broken packages, exiting Cache lock can not be acquired, exiting Checking if connection is metered is skipped. Please install python3-gi package to detect metered connections and skip downloading updates. Checking if system is running on battery is skipped. Please install powermgmt-base package to check power status and skip installing updates when the system is running on battery. Could not open %s for saving list of packages kept back. Error message: %s Giving up on lockfile after %s minutes of delay Initial blacklist: %s Initial whitelist (%s): %s Installing the upgrades failed! Lock could not be acquired (another package manager running?) Maybe systemd-logind service is not running. No /usr/bin/mail or /usr/sbin/sendmail, can not send mail. You probably want to install the mailx package. No packages found that can be upgraded unattended and no pending auto-removals Not running on the development release. Only download, do not even try to install. Package %s is blacklisted. Package %s is marked to be held back. Package installation log: Packages that attempted to upgrade:
 Packages that were auto-removed:
 Packages that were kept from being auto-removed:
 Packages that were successfully auto-removed: %s Packages that were upgraded:
 Packages that will be upgraded: %s Packages with upgradable origin but kept back:
 Progress: %s %% (%s) Removing unused kernel packages: %s Running unattended-upgrades in shutdown mode Simulation, download but do not install Starting unattended upgrades script System is on metered connection, stopping The URI %s failed to download, aborting The list of kept packages can't be calculated in dry-run mode. Unattended upgrade result: %s Unattended-upgrade in progress during shutdown, please don't turn off the computer Unattended-upgrades log:
 Unattended-upgrades stopped. There may be upgrades left to be installed in the next run. Unclean dpkg state detected, trying to correct Upgrade was interrupted Warning: A reboot is required to complete this upgrade, or a previous one.

 You need to be root to run this application [reboot required] error message: %s error message: '%s' package %s not upgraded package %s upgradable but fails to be marked for upgrade (%s) print debug messages print info messages Project-Id-Version: unattended-upgrades
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2022-04-21 05:40+0000
Last-Translator: Luke Na <Unknown>
Language-Team: Simplified Chinese <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
X-Launchpad-Export-Date: 2025-01-30 17:46+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 安装了所有的更新 允许的源：%s 发生了一个错误 发生了一个错误：%s Apt 返回错误，因此惯技模式被禁用 Apt 返回了一个错误，正在退出 自动移除软件包失败。 缓存存在不完整的软件包，退出 无法获取缓存锁，退出 跳过检查连接是否按流量计费。 请安装 python3-gi 包以检测计量连接并跳过下载更新。 跳过检查系统是否使用电池运行。 请安装 powermgmt-base 软件包以检查电源状态并在系统使用电池运行时跳过安装更新。 无法打开 %s 以保存保留的软件包列表。 错误消息：%s 延迟 %s 分钟后放弃锁定文件 初始黑名单：%s 初始白名单（%s）：%s 安装更新失败！ 无法获取锁(另一个软件包管理器在运行？) 或许 systemd-logind 服务没有运行。 没有/usr/bin/mail 或/usr/sbin/sendmail，不能发送邮件。您可能要安装 mailx 包。 没有找到可以无人值守升级的软件包，也没有挂起的自动删除软件包。 没有运行在开发版本上 仅下载，不试图安装。 软件包 %s 已被列入黑名单。 包 %s 被标记为保留。 软件包安装日志： 尝试升级的软件包：
 自动移除的软件包：
 被阻止自动删除的包：
 成功自动删除的包：%s 升级的软件包：
 将要升级的软件包：%s 可更新但保留了原始版本的软件包:
 进度：%s %% （%s） 删除未使用的内核软件包：%s 在关机模式下运行无人值守升级 模拟，下载但不安装 启动无人照管的更新脚本 系统处于按量计费的连接状态，正在停止 URI %s 下载失败，正在中止 在试运行模式下无法计算保留的软件包列表。 无人值守升级结果：%s 在关机过程中正在进行无人值守升级，请勿关闭电源 无人照管更新日志：
 无人值守升级停止。下次运行时可能需要安装升级。 检测到不干净的 dpkg 状态，正在尝试纠正 升级被中断 警告：需要重新启动才能完成现在或之前的升级。

 您需要 roo t的权限来运行这个程序 [需要重启] 错误信息：%s 错误信息：‘%s’ 软件包 %s 没有被升级 程序包 %s 可升级，但未能标记为升级（%s） 打印调试信息 打印信息 