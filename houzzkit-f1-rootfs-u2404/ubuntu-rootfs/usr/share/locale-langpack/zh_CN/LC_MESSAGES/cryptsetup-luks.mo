��    A      $  Y   ,      �     �  �   �     f     �     �     �     �     �     �     �  7   �     6     Q     V     m     |     �     �     �  )   �       ?     4   S     �  %   �  &   �     �  -   	     9	     A	  "   X	  6   {	  >   �	     �	     
  &   '
  M   N
  +   �
  6   �
  #   �
     #  .   3  '   b     �     �     �     �     �       G     ,   _     �     �  "   �     �     �     �                  (   3     \     v  1   �  �  �     f  �   �     B     _     |     �     �     �     �     �  1   �          ,     3     K     X     g     �     �     �     �  '   �     �  &        >  ,   ^     �  2   �  	   �     �  !   �  9     (   J     s     �  $   �  D   �  +      )   ,     V     t     �  '   �     �     �     �           #     D  =   Z  '   �     �     �  !   �     �          &     3     L     P     c  5   �     �  -   �     +   %   $   /   1      &                   =   <      @      ?   *   ;              (   
      A       >             #      0       ,                                   .         "                                        '                   9   -   )   	   :   4   !           5   8   7   2                     3          6    
<action> is one of:
 
<name> is the device to create under %s
<device> is the encrypted device
<key slot> is the LUKS key slot number to modify
<key file> optional key file for the new key for luksAddKey action
 %s is not a LUKS partition
 %s: requires %s as arguments <device> <device> <key slot> <device> <name>  <device> [<new key file>] <name> <name> <device> Align payload at <n> sector boundaries - for luksFormat Argument <action> missing. BITS Can't open device: %s
 Command failed Command successful.
 Create a readonly mapping Display brief usage Do not ask for confirmation Failed to obtain device mapper directory. Help options: How many sectors of the encrypted data to skip at the beginning How often the input of the passphrase can be retried Key %d not active. Can't wipe.
 Key size must be a multiple of 8 bits PBKDF2 iteration time for LUKS (in ms) Print package version Read the key from a file (can be /dev/random) SECTORS Show this help message Shows more detailed error messages The cipher used to encrypt the disk (see /proc/crypto) The hash used to create the encryption key from the passphrase The size of the device The size of the encryption key The start offset in the backend device This is the last keyslot. Device will become unusable after purging this key. This will overwrite data on %s irrevocably. Timeout for interactive passphrase prompt (in seconds) Unable to obtain sector size for %s Unknown action. Verifies the passphrase by asking for it twice [OPTION...] <action> <action-specific>] add key to LUKS device create device dump LUKS partition information formats a LUKS device key %d active, purge first.
 key %d is disabled.
 key material section %d includes too few stripes. Header manipulation?
 memory allocation error in action_luksFormat modify active device msecs open LUKS device as mapping <name> print UUID of LUKS device remove LUKS mapping remove device resize active device secs show device status tests <device> for LUKS partition header unknown hash spec in phdr unknown version %d
 wipes key with number <key slot> from LUKS device Project-Id-Version: cryptsetup
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2009-08-08 13:05+0000
Last-Translator: Tao Wei <weitao1979@gmail.com>
Language-Team: Simplified Chinese <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:29+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 
<action> 是其中之一:
 
<名称> 是这个设备创建在 %s 之下
<设备> 是这个加密的设备
<key slot> 是 LUKS key slot 数字去设置
<key file> optional key file for the new key for luksAddKey action
 %s 不是一个 LUKS 分区
 %s: requires %s 作为参数 <设备> <设备> <key slot> <设备> <名称>  <设备> [<新密钥文件>] <名称> <名称> <设备> 为luksFormat排列有效负荷在<n>扇区边界 缺少<action>参数. 位数 不能打开设备: %s
 命令失败 命令成功.
 创建一个只读映射 显示简短用法 不询问确认 获取设备映射目录失败 帮助选项: 加密数据在开始跳过多少扇区 多久能重试再输入密钥 密钥 %d 没有激活. 不能清除.
 密码长度必须是8的倍数 用于LUKS的PBKDF2 重复时间 (毫秒内) 显示包版本 读取密码从一个文件(可能在 /dev/random) 扇区数 显示该帮助信息 显示更多的详细错误信息 这个密码用于加密这个磁盘(参看 /proc/crypto) hash用于从密钥中创建加密密钥 设备尺寸 加密密码的长度 在后台设备中的开始偏移量 这是最后的 keyslot. 设备将不可用在清除这个密钥后. 这将不能取消地在 %s 上覆盖数据 交互密钥提示的时间限制(秒数) 不能为%s获得扇区大小 未知操作。 通过两次来校验密钥 [选项...] <action> <action-specific>] 添加密钥到LUKS设备 创建设备 复制LUKS分区信息 格式化成一个LUKS设备 密钥 %d 激活, 首先清除.
 密钥 %d 被禁用.
 密钥分区 %d 包含太多的stripes. 处理 Header 吗？
 内存配置错误在 action_luksFormat 设置激活分区 毫秒 打开LUKS设备映射为<名称> 显示LUKS设备的UUID 卸载LUKS 映射 删除设备 改变激活分区大小 秒 显示设备状态 为LUKS分区头检测<设备> 未知的散列分区(hash spec)，在分区头(phdr) 未知版本 %d
 从LUKS 设备用数字<key slot>清除密钥 