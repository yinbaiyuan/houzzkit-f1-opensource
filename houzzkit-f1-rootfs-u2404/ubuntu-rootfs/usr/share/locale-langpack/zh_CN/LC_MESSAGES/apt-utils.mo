��    :      �  O   �      �  )   �     #  "   ?     b     �     �     �     �     �  1        5  ,   D  m   q  #   �  (        ,     0     I     f  %   �  '   �     �     �     �  #     "   +     N     d     ~     �     �  #   �  "   �  "   		  "   ,	  $   O	     t	  "   �	  5   �	  !   �	     
     
     0
     B
  "   `
     �
  �   �
  �   &  &    �   <  �   �  �   �     �     �     �  !   �  #   �  �    .   �     '  %   D     j     �  #   �     �  '   �  $     <   *     g  =   w  n   �  -   $  C   R  
   �     �     �     �  $   �  #        >     J     Z     s  ,   �     �     �     �     	  '   #     K  1   j  1   �  1   �  3      !   4     V  /   u     �     �     �     �  #   �          6  �   R  �   �  <  �  �   �%  �   �&  �   ['  
   /(     :(  #   Z(  4   ~(     �(     +   #      
      6                            4           	                 2              /                   $   .         )             *          !   7       :         "   '                  0   ,                    8       9   &          5      (   -      1   3   %                %s has no binary override entry either
   %s has no override entry
   %s has no source override entry
   %s maintainer is %s not %s
  DeLink %s [%s]
  DeLink limit of %sB hit.
 *** Failed to link %s to %s Archive had no package field Archive has no control record Cannot get debconf version. Is debconf installed? Compress child Compressed output %s needs a compression set DB format is invalid. If you upgraded from an older version of apt, please remove and re-create the database. DB is old, attempting to upgrade %s DB was corrupted, file renamed to %s.old E:  E: Errors apply to file  Error processing contents %s Error processing directory %s Error writing header to contents file Failed to create IPC pipe to subprocess Failed to fork Failed to open %s Failed to read .dsc Failed to read the override file %s Failed to read while computing MD5 Failed to readlink %s Failed to rename %s to %s Failed to resolve %s Failed to stat %s IO to subprocess/file failed Internal error, failed to create %s Malformed override %s line %llu #1 Malformed override %s line %llu #2 Malformed override %s line %llu #3 Malformed override %s line %llu (%s) No selections matched Package extension list is too long Some files are missing in the package file group `%s' Source extension list is too long Tree walking failed Unable to get a cursor Unable to open %s Unable to open DB file %s: %s Unknown compression algorithm '%s' Unknown package record! Usage: apt-dump-solver

apt-dump-solver is an interface to store an EDSP scenario in
a file and optionally forwards it to another solver.
 Usage: apt-extracttemplates file1 [file2 ...]

apt-extracttemplates is used to extract config and template files
from debian packages. It is used mainly by debconf(1) to prompt for
configuration questions before installation of packages.
 Usage: apt-ftparchive [options] command
Commands: packages binarypath [overridefile [pathprefix]]
          sources srcpath [overridefile [pathprefix]]
          contents path
          release path
          generate config [groups]
          clean config

apt-ftparchive generates index files for Debian archives. It supports
many styles of generation from fully automated to functional replacements
for dpkg-scanpackages and dpkg-scansources

apt-ftparchive generates Package files from a tree of .debs. The
Package file contains the contents of all the control fields from
each package as well as the MD5 hash and filesize. An override file
is supported to force the value of Priority and Section.

Similarly apt-ftparchive generates Sources files from a tree of .dscs.
The --source-override option can be used to specify a src override file

The 'packages' and 'sources' command should be run in the root of the
tree. BinaryPath should point to the base of the recursive search and 
override file should contain the override flags. Pathprefix is
appended to the filename fields if present. Example usage from the 
Debian archive:
   apt-ftparchive packages dists/potato/main/binary-i386/ > \
               dists/potato/main/binary-i386/Packages

Options:
  -h    This help text
  --md5 Control MD5 generation
  -s=?  Source override file
  -q    Quiet
  -d=?  Select the optional caching database
  --no-delink Enable delinking debug mode
  --contents  Control contents file generation
  -c=?  Read this configuration file
  -o=?  Set an arbitrary configuration option Usage: apt-internal-planner

apt-internal-planner is an interface to use the current internal
installation planner for the APT family like an external one,
for debugging or the like.
 Usage: apt-internal-solver

apt-internal-solver is an interface to use the current internal
resolver for the APT family like an external one, for debugging or
the like.
 Usage: apt-sortpkgs [options] file1 [file2 ...]

apt-sortpkgs is a simple tool to sort package information files.
By default it sorts by binary package information, but the -s option
can be used to switch to source package ordering instead.
 W:  W: Unable to read directory %s
 W: Unable to stat %s
 Waited for %s but it wasn't there realloc - Failed to allocate memory Project-Id-Version: apt 2.5.3
Report-Msgid-Bugs-To: APT Development Team <deity@lists.debian.org>
PO-Revision-Date: 2024-08-14 13:06+0000
Last-Translator: Boyuan Yang <073plan@gmail.com>
Language-Team: Chinese (simplified) <debian-l10n-chinese@lists.debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 16:27+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
   %s 中没有二进制文件的 override 项
   %s 中没有 override 项
   %s 没有源代码的 override 项
   %s 的维护者 %s 并非 %s
  DeLink %s [%s]
  达到了 DeLink 的上限 %sB。
 *** 无法将 %s 链接到 %s 归档文件没有包含 package 字段 归档文件没有包含控制字段 无法获得 debconf 的版本。您安装了 debconf 吗？ 压缩子进程 压缩后的输出文件 %s 要求有一个压缩文件集合 数据库格式无效。如果您是从一个老版本的 apt 升级而来，请删除数据库并重建它。 数据库已过期，现尝试进行升级 %s 数据库被损坏，该数据库文件的文件名已改成 %s.old 错误：  错误：处理文件时出错  处理目录 %s 时出错 处理目录 %s 时出错 将头写入到目录文件时出错 无法为子进程创建 IPC 管道 无法 fork 无法打开 %s 读取 .dsc 文件失败 无法读取 override 文件 %s 在计算 MD5 校验和时无法读取数据 无法读取符号链接 %s 无法将 %s 重命名为 %s 无法解析 %s 无法获得 %s 的状态 无法对子进程或文件进行读写 内部错误，无法创建 %s override 文件 %s 第 %llu 行的格式有误 #1 override 文件 %s 第 %llu 行的格式有误 #2 override 文件 %s 第 %llu 行的格式有误 #3 override 文件 %s 第 %llu (%s) 行的格式有误 没有任何选定项是匹配的 软件包的扩展列表太长 软件包文件组“%s”中缺少一些文件 源扩展列表太长 无法遍历目录树 无法获得游标 无法打开 %s 无法打开数据库文件 %s：%s 未知的压缩算法“%s” 未知的软件包记录！ 用法：apt-dump-solver

apt-dump-solver 是一个在文件中存储EDSP情景的接口，
并可将其传送到另一个解决器。
 用法： apt-extracttemplates 文件1 [文件2 ...]

apt-extracttemplates 可以从 debian 软件包中解压出配置文件和模板
信息。它主要被 debconf(1) 用于在安装软件包前询问用户配置问题。
 用法： apt-ftparchive [选项] 命令
命令： packages 二进制软件包搜索路径 [overridefile [路径前缀]]
       sources 源代码包搜索路径 [overridefile [路径前缀]]
       contents 搜索路径
       release 搜索路径
       generate 配置文件 [groups]
       clean 配置文件

apt-ftparchive 被用来为 Debian 软件包生成索引文件。它能支持
多种生成索引的方式，从全自动的索引生成到在功能上取代 dpkg-scanpackages 
和 dpkg-scansources，都能游刃有余

apt-ftparchive 能依据一个由 .deb 文件构成的文件树生成 Package 文件。
Package 文件里不仅注有每个软件包的 MD5 校验码和文件大小，
还有软件包的所有控制字段的内容。该软件同时支持 override 文件，
通过它可以强制指定软件包的优先级及其所属的软件类别。

与上面类似，apt-ftparchive 也能由 .dsc 的文件树生成 Source 文件。
可以通过使用 --source-override 选项来指定一个 override 文件

使用“packages”和“source”命令时，必须在文件树的根部执行本程序。
二进制包的搜索路径一定要是递归搜索的底层，而且 override 文件里
应该注明 override 的标志。若指定了路径前缀，那么它会被加到文件名前面。
下面有个来自 Debian 文档的例子：
   apt-ftparchive packages dists/potato/main/binary-i386 > \
               dists/potato/main/binary-i386/Packages

选项:
  -h    本帮助文档
  --md5 使之生成 MD5 校验和
  -s=?  源代码包 override 文件
  -q    输出精简信息
  -d=?  指定可选的缓存数据库
  -d=?  使用另一个可选的缓存数据库
  --no-delink 开启delink的调试模式
  --contents  使之生成控制内容文件
  -c=?  读取指定配置文件
  -o=?  设置任意指定的配置选项 用法： apt-internal-planner

apt-internal-planner 是一个可以像外部规划器那样使用当前的APT家族内部
安装顺序规划器的接口，以便调试等用途。
 用法： apt-internal-solver

apt-internal-solver 是一个可以像外部解析器那样使用当前的APT家族内部
依赖解析器的接口，以便调试等用途。
 用法： apt-sortpkgs [选项] 文件1 [文件2 ...]

简易工具 apt-sortpkgs 用于排序软件包信息。
它默认对二进制包信息排序，但是 -s 选项可以将其切换为
对源码包排序。
 警告：  警告：无法读取目录 %s
 警告：无法获得 %s 的状态
 等待子进程 %s 的退出，但是它并不存在 realloc - 分配内存失败 