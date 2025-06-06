��    _                   l   	     v  �  �  b   N  M   �  H   �  p   H  �   �  q   [  �   �  �   �  �   �  �   d  9     #   >     b          �  )   �  	   �  3   �       �   0      �  ,   �  $        2      G     h     �  #   �  !   �     �       <     %   W  %   }     �     �     �     �     
          -     D     ]  �   }  &   >     e     �     �  �   �  d   �     �       $   &  u   K  C   �  =        C  &   \  +   �     �  (   �  )   �          ,    F  (   N  /  w  �   �!  }   c"  .   �"  F   #  "   W#  -   z#     �#  
   �#     �#  2   �#  $   $  ,   >$  '   k$  '   �$     �$     �$  +   �$     %     %     +%     3%     <%     C%     K%  �  R%  ~   N'     �'    �'  b   c+  V   �+  B   ,  �   `,  �   �,  u   �-  �   �-  %  �.  �   �/  �   �0  D   h1  )   �1     �1     �1     2  1    2     R2  ?   [2     �2  �   �2     T3  ,   n3  $   �3     �3     �3      �3     4  "   44      W4     x4  $   �4  ;   �4  $   �4  $   5     85  &   S5  '   z5     �5     �5     �5     �5     �5     6  �   16  '   7     ,7     <7     P7  �   b7  _    8     `8     t8  $   �8  �   �8  G   ]9  @   �9     �9  #   �9  )   #:     M:  !   j:  )   �:     �:     �:  �  �:  .   �>  I  ?  �   `A  �   B  *   �B  *   �B  "   �B  <   C  %   WC     }C     �C  /   �C  &   �C  2   �C  "   'D  ,   JD     wD     ~D  /   �D     �D     �D  	   �D  	   �D     �D     E     E     2   ;      *             8   K   1   :   ?                   7   J   ,          P       =   D      .         X   U   ^       M   6       /          T   O                     E              )       &      -       G   (          L   !   #      \                 I      >          Q      _   Y   <   S       5   "           	   R       H   4   F   [   3          '   B      A   %       9   N           $   +   V   Z              C       ]      W   0   @      
                    
  PID    start at this PID; default is 1 (init)
  USER   show only trees rooted at processes of this user

 
Display a tree of processes.

        killall -l, --list
       killall -V, --version

  -e,--exact          require exact match for very long names
  -I,--ignore-case    case insensitive process name match
  -g,--process-group  kill process group instead of process
  -y,--younger-than   kill processes younger than TIME
  -o,--older-than     kill processes older than TIME
  -i,--interactive    ask for confirmation before killing
  -l,--list           list all known signal names
  -q,--quiet          don't print complaints
  -r,--regexp         interpret NAME as an extended regular expression
  -s,--signal SIGNAL  send this signal instead of SIGTERM
  -u,--user USER      kill only process(es) running as USER
  -v,--verbose        report if the signal was successfully sent
  -V,--version        display version information
  -w,--wait           wait for processes to die
  -n,--ns PID         match processes that belong to the same namespaces
                      as PID
   -4,--ipv4             search IPv4 sockets only
  -6,--ipv6             search IPv6 sockets only
   -C, --color=TYPE    color process by attribute
                      (age)
   -Z, --security-context
                      show security attributes
   -Z,--context REGEXP kill only process(es) having context
                      (must precede other arguments)
   -a, --arguments     show command line arguments
  -A, --ascii         use ASCII line drawing characters
  -c, --compact-not   don't compact identical subtrees
   -g, --show-pgids    show process group ids; implies -c
  -G, --vt100         use VT100 line drawing characters
   -h, --highlight-all highlight current process and its ancestors
  -H PID, --highlight-pid=PID
                      highlight this process and its ancestors
  -l, --long          don't truncate long lines
   -n, --numeric-sort  sort output by PID
  -N TYPE, --ns-sort=TYPE
                      sort output by this namespace type
                              (cgroup, ipc, mnt, net, pid, time, user, uts)
  -p, --show-pids     show PIDs; implies -c
   -s, --show-parents  show parents of the selected process
  -S, --ns-changes    show namespace transitions
  -t, --thread-names  show full thread names
  -T, --hide-threads  hide threads, show only processes
   -u, --uid-changes   show uid transitions
  -U, --unicode       use UTF-8 (Unicode) line drawing characters
  -V, --version       display version information
   udp/tcp names: [local_port][,[rmt_host][,[rmt_port]]]

 %*s USER        PID ACCESS COMMAND
 %s is empty (not mounted ?)
 %s: Invalid option %s
 %s: no process found
 %s: unknown signal; %s -l lists signals.
 (unknown) /proc is not mounted, cannot stat /proc/self/stat.
 Bad regular expression: %s
 CPU Times
  This Process    (user system guest blkio): %6.2f %6.2f %6.2f %6.2f
  Child processes (user system guest):       %6.2f %6.2f %6.2f
 Can't get terminal capabilities
 Cannot allocate memory for matched proc: %s
 Cannot find socket's device number.
 Cannot find user %s
 Cannot open /proc directory: %s
 Cannot open /proc/net/unix: %s
 Cannot open a network socket.
 Cannot open protocol file "%s": %s
 Cannot resolve local port %s: %s
 Cannot stat %s: %s
 Cannot stat file %s: %s
 Copyright (C) 1993-2024 Werner Almesberger and Craig Small

 Copyright (C) 2007 Trent Waddington

 Copyright (C) 2009-2024 Craig Small

 Could not kill process %d: %s
 Error attaching to pid %i
 Invalid namespace PID Invalid namespace name Invalid option Invalid time format Kill %s(%s%d) ? (y/N)  Kill process %d ? (y/N)  Killed %s(%s%d) with signal %d
 Memory
  Vsize:       %-10s
  RSS:         %-10s 		 RSS Limit: %s
  Code Start:  %#-10lx		 Code Stop:  %#-10lx
  Stack Start: %#-10lx
  Stack Pointer (ESP): %#10lx	 Inst Pointer (EIP): %#10lx
 Namespace option requires an argument. No process specification given No processes found.
 No such user name: %s
 PSmisc comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it under
the terms of the GNU General Public License.
For more information about these matters, see the files named COPYING.
 Page Faults
  This Process    (minor major): %8lu  %8lu
  Child Processes (minor major): %8lu  %8lu
 Press return to close
 Process %d not found.
 Process with pid %d does not exist.
 Process, Group and Session IDs
  Process ID: %d		  Parent ID: %d
    Group ID: %d		 Session ID: %d
  T Group ID: %d

 Process: %-14s		State: %c (%s)
  CPU#:  %-3d		TTY: %s	Threads: %ld
 Scheduling
  Policy: %s
  Nice:   %ld 		 RT Priority: %ld %s
 Signal %s(%s%d) ? (y/N)  Specified filename %s does not exist.
 Specified filename %s is not a mountpoint.
 TERM is not set
 Unable to allocate memory for proc_info
 Unable to open stat file for pid %d (%s)
 Unable to scan stat file Unknown local port AF %d
 Usage: fuser [-fIMuvw] [-a|-s] [-4|-6] [-c|-m|-n SPACE]
             [-k [-i] [-SIGNAL]] NAME...
       fuser -l
       fuser -V
Show which processes use the named files, sockets, or filesystems.

  -a,--all              display unused files too
  -i,--interactive      ask before killing (ignored without -k)
  -I,--inode            use always inodes to compare files
  -k,--kill             kill processes accessing the named file
  -l,--list-signals     list available signal names
  -m,--mount            show all processes using the named filesystems or
                        block device
  -M,--ismountpoint     fulfill request only if NAME is a mount point
  -n,--namespace SPACE  search in this name space (file, udp, or tcp)
  -s,--silent           silent operation
  -SIGNAL               send this signal instead of SIGKILL
  -u,--user             display user IDs
  -v,--verbose          verbose output
  -w,--writeonly        kill only processes with write access
  -V,--version          display version information
 Usage: killall [OPTION]... [--] NAME...
 Usage: peekfd [-8] [-n] [-c] [-d] [-V] [-h] <pid> [<fd> ..]
    -8, --eight-bit-clean        output 8 bit clean streams.
    -n, --no-headers             don't display read/write from fd headers.
    -c, --follow                 peek at any new child processes too.
    -t, --tgid                   peek at all threads where tgid equals <pid>.
    -d, --duplicates-removed     remove duplicate read/writes from the output.
    -V, --version                prints version info.
    -h, --help                   prints this help.

  Press CTRL-C to end output.
 Usage: prtstat [options] PID ...
       prtstat -V
Print information about a process
    -r,--raw       Raw display of information
    -V,--version   Display version information and exit
 Usage: pstree [-acglpsStTuZ] [ -h | -H PID ] [ -n | -N type ]
              [ -A | -G | -U ] [ PID | USER ]
   or: pstree -V
 You can only use files with mountpoint options You cannot search for only IPv4 and only IPv6 sockets at the same time You must provide at least one PID. all option cannot be used with silent option. asprintf in print_stat failed.
 disk sleep fuser (PSmisc) %s
 killall: %s lacks process entries (not mounted ?)
 killall: Bad regular expression: %s
 killall: Cannot get UID from process status
 killall: Maximum number of names is %d
 killall: skipping partial match %s(%d)
 paging peekfd (PSmisc) %s
 procfs file for %s namespace not available
 prtstat (PSmisc) %s
 pstree (PSmisc) %s
 running sleeping traced unknown zombie Project-Id-Version: psmisc 23.7-rc1
Report-Msgid-Bugs-To: csmall@dropbear.xyz
PO-Revision-Date: 2024-03-31 18:17+0000
Last-Translator: Wenbin Lv <Unknown>
Language-Team: Chinese (simplified) <i18n-zh@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:18+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
X-Bugs: Report translation errors to the Language-Team address.
 
  进程号 从指定进程号开始；默认为 1（init）
  用户   仅显示从指定用户的进程开始的进程树

 
显示进程树。

        killall -l, --list
      killall -V, --version

  -e,--exact          对长名字要求严格匹配
  -I,--ignore-case    匹配进程名时忽略大小写
  -g,--process-group  杀死进程组而不是进程
  -y,--younger-than   杀死比指定<时间>年轻的进程
  -o,--older-than     杀死比指定<时间>年老的进程
  -i,--interactive    在杀死进程前要求确认
  -l,--list           列出所有的信号名
  -q,--quiet          不要打印抱怨信息
  -r,--regexp         将 "进程名" 视为扩展正则表达式
  -s,--signal 信号    发送指定 "信号" 而不是 SIGTERM
  -u,--user 用户      仅杀死指定 "用户" 的进程
  -v,--verbose        报告信号是否成功送出
  -V,--version        显示版本信息
  -w,--wait           等待进程死亡
  -n,--ns 进程号      匹配与指定<进程号>具有相同命名空间的进程
   -4,--ipv4             仅查找 IPv4 套接字
  -6,--ipv6             仅查找 IPv6 套接字
   -C, --color=类型    按照指定属性对进程上色
                      (age)
   -Z, --security-context
                      显示安全属性
   -Z,--context 正则表达式 仅杀死含有指定上下文的进程
                          (必须在其他参数前使用)
   -a, --arguments     显示命令行参数
  -A, --ascii         使用 ASCII 行绘制字符
  -c, --compact-not   不要对完全相同的子树进行压缩
   -g, --show-pgids    显示进程组 ID；隐含启用 -c 选项
  -G, --vt100         使用 VT100 行绘制字符
   -h, --highlight-all 高亮显示当前进程和其所有祖先
  -H PID, --highlight-pid=PID
                      高亮显示指定 PID 对应的进程和其所有祖先
  -l, --long          不要截断长行
   -n, --numeric-sort  按照 PID 对输出进行排序
  -N 类型, --ns-sort=类型
                      按照指定命名空间类型对输出进行排序
                              (cgroup, ipc, mnt, net, pid, time, user, uts)
  -p, --show-pids     显示 PID；隐含启用 -c 选项
   -s, --show-parents  显示所选进程的父进程
  -S, --ns-changes    显示命名空间的变化
  -t, --thread-names  显示完整线程名称
  -T, --hide-threads  隐藏线程，只显示进程
   -u, --uid-changes   显示用户 ID（UID）的变化
  -U, --unicode       使用 UTF-8（Unicode）的行绘制字符
  -V, --version       显示版本信息
   udp/tcp 名字: [本地端口][,[远程主机][,[远程端口]]]

 %*s 用户     进程号 权限   命令
 %s 是空的 (未挂载?)
 %s：无效的选项 %s
 %s: 未找到进程
 %s: 未知的信号; %s -l 显示信号列表。
 (未知) /proc 未被挂载，无法取得 /proc/self/stat 的状态。
 错误的正则表达式: %s
 CPU 时间
  此进程 (用户 系统 访客 区块输出入)：%6.2f %6.2f %6.2f %6.2f
  子进程 (用户 系统 访客)：           %6.2f %6.2f %6.2f
 无法获取终端功能
 无法为已找到的进程分配内存: %s
 无法找到 socket 的设备号。
 无法找到用户 %s
 无法打开 /proc 目录: %s
 无法打开 /proc/net/unix: %s
 无法打开网络端口。
 无法打开协议文件 "%s": %s
 无法解析本地端口 %s: %s
 无法分析 %s: %s
 无法获取 %s 的文件状态: %s
 Copyright © 1993-2024 Werner Almesberger 和 Craig Small

 Copyright © 2007 Trent Waddington

 Copyright © 2009-2024 Craig Small

 无法杀死进程 %d: %s
 绑定到 %i 号进程时发生错误
 无效的命名空间进程号（PID） 无效的命名空间名 无效的选项 无效的时间格式 杀死 %s(%s%d) ? (y/N)  杀死进程 %d ? (y/N)  %s(%s%d) 被信号 %d 杀死
 内存
  Vsize：      %-10s
  RSS：        %-10s		 RSS 限制：%s
  程序开始：   %#-10lx		 程序停止： %#-10lx
  堆栈开始：   %#-10lx
  堆栈指针 (ESP)：%#10lx	 指令指针 (EIP)：%#10lx
 命名空间选项需要一个参数。 未指定进程 未找到进程。
 无用户名: %s
 PSmisc 不提供任何保证。
该程序为自由软件，欢迎你在 GNU 通用公共许可证 (GPL) 下重新发布。
详情可参阅 COPYING 文件。
 分页错误
  此进程 (次要 主要)：%8lu  %8lu
  子进程 (次要 主要)：%8lu  %8lu
 按回车以关闭
 未找到进程 %d。
 具有 pid %d 的进程不存在。
 进程、群组和运行阶段识别码
    进程识别号：%d		     上层识别号：%d
    群组识别号：%d		 运行阶段识别码：%d
  T 群组识别号：%d

 进程：  %-14s		状态：%c (%s)
  CPU#: %-3d		TTY：%s	线程：%ld
 调度
  策略：%s
  友好：%ld 		 实时优先级：%ld %s
 信号 %s(%s%d) ? (y/N)  指定的文件名 %s 不存在。
 指定的文件名 %s 并非挂载点。
 未设置 TERM 环境变量
 无法为 proc_info 分配内存
 无法打开 pid %d (%s) 的 stat 文件
 无法扫描 stat 文件 未知本地端口 AF %d
 用法：fuser [-fIMuvw] [-a|-s] [-4|-6] [-c|-m|-n 命名空间]
            [-k [-i] [-信号]] 名字...
      fuser -l
      fuser -V
显示哪些进程使用指定的文件、端口或文件系统。

  -a,--all              也显示未使用的文件
  -i,--interactive      杀死程序前询问 (未指定 -k 选项时被忽略)
  -I,--inode            总是使用 inode 来比较文件
  -k,--kill             杀死访问指定文件的进程
  -l,--list-signals     列出可用的信号名
  -m,--mount            显示所有使用指定文件系统或块设备的进程
  -M,--ismountpoint     只在 <名字> 为挂载点时完成要求
  -n,--namespace 空间   在指定命名空间中查找 (file、udp 或 tcp)
  -s,--silent           不输出信息
  -信号                 发送指定的 "信号" 而不是 SIGKILL
  -u,--user             显示用户 ID
  -v,--verbose          输出更多信息
  -w,--writeonly        只杀死有权写入的进程
  -V,--version          显示版本信息
 用法: killall [选项]... [--] 进程名...
 用法: peekfd [-8] [-n] [-c] [-d] [-V] [-h] <进程号> [<文件号> ..]
    -8, --eight-bit-clean        输出干净的8位数据流。
    -n, --no-headers             不显示文件描述符头的读写信息。
    -c, --follow                 也检测新的子进程。
    -t, --tgid                   检测 tgid 等于<进程号>的所有线程。
    -d, --duplicates-removed     从输出中删除重复的读写信息。
    -V, --version                输出版本信息。
    -h, --help                   输出本帮助信息。

  按下 CTRL-C 来终止输出。
 用法：prtstat [选项] PID…
      prtstat -V
打印进程的相关信息
    -r,--raw       显示信息的原始样式
    -V,--version   显示版本信息然后离开
 用法：pstree [-acglpsStTuZ] [ -h | -H 进程号 ] [ -n | -N 类型 ]
              [ -A | -G | -U ] [ 进程号 | 用户 ]
  或：pstree -V
 你只能使用有挂载点选项的文件 你无法同时搜索 IPv4 和 IPv6 端口 您必须提供至少一个 PID。 所有选项都不能与不输出信息选项同时使用。 print_stat 中的 asprintf 失败。
 磁盘暂停 fuser (PSmisc) %s
 killall: %s 不含进程信息项 (未挂载?)
 killall: 不当的正则表达式: %s
 killall: 无法从进程状态获取用户ID(UID)
 killall: 最大名字数量是 %d
 killall: 跳过部分符合的部分 %s(%d)
 分页 peekfd (PSmisc) %s
 适用 %s 命名空间的 proc 文件不可用
 prtstat (PSmisc) %s
 pstree (PSmisc) %s
 运行中 暂停中 追踪 未知 僵尸 