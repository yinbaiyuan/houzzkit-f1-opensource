��          �   %   �      p  4   q     �     �     �      �     �       $   -     R     `  *     T   �  <   �  8   <  V   u     �  �   �  �   �  5   �  :   �     �     �     	  #         D  �   X  	   "  �  ,     �	     �	      
     
     &
  %   C
     i
  !   |
     �
     �
     �
  I   �
  $   *  !   O  o   q     �  �   �  �   �  )   B  /   l     �     �     �     �     �  �   �     �                                                  	                                                       
                  Authentication is needed to diagnose graphics issues Debug Diagnose Graphics Issues Disable _PAT memory Disable _VESA framebuffer driver Disable bootloader _graphics Display boot messages Enable automatic crash bug reporting Error Message Extra graphics _debug messages List dates on which updates were performed Makes dmesg logs more verbose with details about 3d, plymouth, and monitor detection Only include entries from this date and earlier (YYYY/MM/DD) Only include entries from this date forward (YYYY/MM/DD) Removes splash and quiet from kernel options so you can see kernel details during boot Report an Xorg Bug The grub bootloader has a graphics mode using the VESA framebuffer driver which can sometimes interfere with later loading of the proper video driver.  Checking this forces grub to use text mode only. This pagetable extension can interfere with the memory management of proprietary drivers under certain situations and cause lagging or failures to allocate video memory, so turning it off can prevent those problems. Troubleshoot failure to start a graphical X11 session Turns on the Apport crash detection and bug reporting tool View Errors Workarounds X Diagnostics Settings X.org Diagnostic and Repair Utility Xorg Error Messages vesafb is loaded early during boot so the boot logo can display, but can cause issues when switching to a real graphics driver.  Checking this prevents vesafb from loading so these issues do not occur. xdiagnose Project-Id-Version: xdiagnose
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2014-04-02 02:37+0000
Last-Translator: shijing <jingshi@ubuntukylin.com>
Language-Team: Chinese (Simplified) <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 18:31+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
 诊断图形问题需要认证 调试 诊断图形问题 禁用 _PAT 内存 禁用 _VESA 帧缓冲驱动 禁用图形化启动引导程序(_G) 显示启动信息 崩溃时自动上报错误信息 错误消息 更多图像调试信息 显示执行更新的时间 使 dmesg 详细记录 3D、plymouth 以及显示器检测相关的信息 只包含此日期及之前的记录 只包含此日期之后的记录 在内核启动参数中删除“splash”和"quite“选项，以在屏幕上显示启动过程的详细信息 报告 Xorg 错误 grub 引导程序的图形模式使用了 VESA 帧缓冲驱动，有时可能会影响后续加载显卡驱动程序。勾选此项，以强制 grub 使用文本模式。 页表扩展用在某些情况下影响专有驱动程序的内存管理，并导致分配显卡内存延迟或失败，将此项关闭可以避免这些问题。 调试启动 X11 会话时发生的故障 启动 Apport 崩溃检测和错误报告工具 查看错误 迂回修正 X 诊断工具设置 X.org 诊断和修复工具 Xorg 错误信息 在系统启动初期加载 vesafb 以显示启动徽标，这可能导致切换到真正的显卡驱动程序时出现问题。勾选此项，禁止加载 vesafb 可以避免这些问题。 X 诊断工具 