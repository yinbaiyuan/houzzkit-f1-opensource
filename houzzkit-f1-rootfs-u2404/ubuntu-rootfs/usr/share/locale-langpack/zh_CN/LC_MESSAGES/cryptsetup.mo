��          �   %   �      P     Q  �   g     &     C     L     `     z     �     �     �  %   �     �     �  "     M   4  +   �     �     �     �     �          %     :  (   M  1   v  �  �     I  �   e     %     B     K     _     |     �     �     �     �     �     �  !   	  D   #	  +   h	     �	     �	     �	     �	     �	     
      
     3
  -   R
                                                                        
                                    	                 
<action> is one of:
 
<name> is the device to create under %s
<device> is the encrypted device
<key slot> is the LUKS key slot number to modify
<key file> optional key file for the new key for luksAddKey action
 %s: requires %s as arguments <device> <device> <key slot> <device> [<new key file>] <name> Argument <action> missing. Display brief usage Help options: Key size must be a multiple of 8 bits Print package version Show this help message Shows more detailed error messages This is the last keyslot. Device will become unusable after purging this key. This will overwrite data on %s irrevocably. Unknown action. add key to LUKS device dump LUKS partition information formats a LUKS device print UUID of LUKS device resize active device show device status tests <device> for LUKS partition header wipes key with number <key slot> from LUKS device Project-Id-Version: cryptsetup
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2009-09-29 07:47+0000
Last-Translator: Wylmer Wang <Unknown>
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
 %s: requires %s 作为参数 <设备> <设备> <key slot> <设备> [<新密钥文件>] <名称> 缺少<action>参数. 显示简短用法 帮助选项 密码长度必须是8的倍数 显示包版本 显示该帮助信息 显示更多的详细错误信息 这是最后的 keyslot. 设备将不可用在清除这个密钥后. 这将不能取消地在 %s 上覆盖数据 未知参数 添加密钥到LUKS设备 复制LUKS分区信息 格式化成一个LUKS设备 显示LUKS设备的UUID 改变激活分区大小 显示设备状态 为LUKS分区头检测<设备> 从LUKS 设备用数字<key slot>清除密钥 