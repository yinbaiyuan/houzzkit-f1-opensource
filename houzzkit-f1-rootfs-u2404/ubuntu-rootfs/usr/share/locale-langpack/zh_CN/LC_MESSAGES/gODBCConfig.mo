��    F      L  a   |                      	                     '  ,   4     a  &   s     �     �  $   �     �                    '     3  
   :     E     T     \  	   m     w  
   |     �     �     �     �     �  �   �    �     �
     �
     �
     �
     �
             )   7     a  	   g  
   q  �   |  �  -  E  �  �  %  �   �  �  �  ]     
   t       
   �  �   �  +   /     [  �   d     �          $     C     `  ,   y     �     �     �  D  �  �    �  �     J     L     S     Z     g     n  	   u          �     �     �     �  )   �  #     	   B     L     P     `     g     t     �     �     �     �     �  
   �     �                7     M  �   g  �  �     �     �     �     �        $        D  ?   c     �     �  	   �  �   �  [  R   6  �!  �  �"  �   l$  �  K%  X   �&     %'     2'     9'  �   @'  '   �'  	   &(  �   0(     �(     �(      �(  #   )     9)  %   W)     })     �)     �)  9  �)  �  �*                  @          :   <   7       4                  ?          %       ;   9           >         *            
   )   .   0      1          E   /       "   F      2                             D          A   -       5                       +          '   $       #         C   6              (   =          ,          B   &   3          	   !   8      About Add Application Browse Config Configure... Could not construct a property list for (%s) Could not load %s Could not write property list for (%s) Could not write to %s Could not write to (%s) Couldn't create pixmap from file: %s Couldn't find pixmap file: %s Credits DSN Database System Description Driver Driver Lib Driver Manager Drivers Enter a DSN name FileUsage Name ODBCConfig ODBCConfig - Credits ODBCConfig - Database Systems ODBCConfig - Drivers ODBCConfig - odbc.ini ODBCConfig - odbcinst.ini Open DataBase Connectivity (ODBC) was developed to be an Open and portable standard for accessing data. unixODBC implements this standard for Linux/UNIX. Perhaps the most common type of Database System today is an SQL Server

SQL Servers with Heavy Functionality
  ADABAS-D
  Empress
  Sybase - www.sybase.com
  Oracle - www.oracle.com

SQL Servers with Lite Functionality
  MiniSQL
  MySQL
  Solid

The Database System may be running on the local machine or on a remote machine. It may also store its information in a variety of ways. This does not matter to an ODBC application because the Driver Manager and the Driver provides a consistent interface to the Database System. Remove Select File Select a DSN to Remove Select a DSN to configure Select a driver to Use Select a driver to configure Select a driver to remove Select the DRIVER to use or Add a new one Setup Setup Lib System DSN System data sources are shared among all users of this machine.These data sources may also be used by system services. Only the administrator can configure system data sources. The Application communicates with the Driver Manager using the standard ODBC calls.

The application does not care; where the data is stored, how it is stored, or even how the system is configured to access the data.

The Application only needs to know the data source name (DSN)

The Application is not hard wired to a particular database system. This allows the user to select a different database system using the ODBCConfig Tool. The Driver Manager carries out a number of functions, such as:
1. Resolve data source names via odbcinst lib)
2. Loads any required drivers
3. Calls the drivers exposed functions to communicate with the database. Some functionality, such as listing all Data Source, is only present in the Driver Manager or via odbcinst lib). The ODBC Drivers contain code specific to a Database System and provides a set of callable functions to the Driver Manager.
Drivers may implement some database functionality when it is required by ODBC and is not present in the Database System.
Drivers may also translate data types.

ODBC Drivers can be obtained from the Internet or directly from the Database vendor.

Check http://www.unixodbc.org for drivers These drivers facilitate communication between the Driver Manager and the data server. Many ODBC drivers  for Linux can be downloaded from the Internet while others are obtained from your database vendor. This is the main configuration file for ODBC.
It contains Data Source configuration.

It is used by the Driver Manager to determine, from a given Data Source Name, such things as the name of the Driver.

It is a simple text file but is configured using the ODBCConfig tool.
The User data sources are typically stored in ~/.odbc.ini while the System data sources are stored in /etc/odbc.ini
 This is the program you are using now. This program allows the user to easily configure ODBC. Trace File Tracing Tracing On Tracing allows you to create logs of the calls to ODBC drivers. Great for support people, or to aid you in debugging applications.
You must be 'root' to set Unable to find a Driver line for this entry User DSN User data source configuration is stored in your home directory. This allows you configure data access without having to be system administrator gODBCConfig - Add DSN gODBCConfig - Appication gODBCConfig - Configure Driver gODBCConfig - Driver Manager gODBCConfig - New Driver gODBCConfig - ODBC Data Source Administrator http://www.unixodbc.org odbc.ini odbcinst.ini odbcinst.ini contains a list of all installed ODBC Drivers. Each entry also contains some information about the driver such as the file name(s) of the driver.

An entry should be made when an ODBC driver is installed and removed when the driver is uninstalled. This can be done using ODBCConfig or the odbcinst command tool. unixODBC consists of the following components

- Driver Manager
- GUI Data Manager
- GUI Config
- Several Drivers and Driver Config libs
- Driver Code Template
- Driver Config Code Template
- ODBCINST lib
- odbcinst (command line tool for install scripts)
- INI lib
- LOG lib
- LST lib
- TRE lib
- SQI lib
- isql (command line tool for SQL)

All code is released under GPL and the LGPL license.
 Project-Id-Version: unixodbc
Report-Msgid-Bugs-To: FULL NAME <EMAIL@ADDRESS>
PO-Revision-Date: 2008-03-04 20:16+0000
Last-Translator: Tao Wei <weitao1979@gmail.com>
Language-Team: Chinese (China) <zh_CN@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 17:05+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
   关于 添加 应用程序 浏览 配置 配置… 不能为(%s)构建属性列表 不能加载%s 不能为(%s)写入属性列表 不能写入到%s 不能写入到(%s) 未能由文件%s创建象图映射文件 未能找到象图映射文件：%s 贡献者 DSN 数据库系统 描述 驱动程序 驱动程序数据库 驱动程序管理器 驱动程序 输入一个DSN名称 文件使用方法 名称 ODBC配置 gODBC配置－贡献者 ODBC配置－数据库系统 ODBC配置－驱动程序 ODBC配置－odbc.ini ODBC配置－odbcinst.ini 开放式数据库互联（ODBC）被开发成一个开放性的、便捷的数据库访问标准。unixODBC对Linux/UNIX采用的就是这个标准。 也许现在大多数的数据库系统类型都是SQL数据库

重量级SQL数据库
  ADABAS-D
  Empress
  Sybase - www.sybase.com
  Oracle - www.oracle.com

轻量级SQL数据库
  MiniSQL
  MySQL
  Solid

数据库系统可能运行于本地或远程机器上。可能的存储数据方式也有很多种。但这些对于ODBC应用程序来说都不重要，因为驱动管理和驱动程序提供了联接到数据库的统一接口。 删除 选择文件 选择要删除的DSN 选择要进行配置的DSN 选择要使用的驱动程序 选择要进行配置的驱动程序 选择要删除的驱动程序 选择要使用的驱动程序，或者添加新的驱动程序 安装 设置数据库 系统DSN 系统数据源由本机所有用户共享。这些数据源也可以被系统服务所调用。只有管理员有权配置系统数据源。 本程序使用标准的ODBC调用来与驱动管理程序通信。

本程序与数据的存储位置，存储方式，以及系统对数据连接方式的配置无关。

本程序只需要数据源名称即可 (DSN)

本程序并不与特定的数据库系统绑定。这样可以使用户通过ODBC配置工具选择不同的数据库系统。 本驱动管理程序可以完成许多功能，如下所示：
1. 通过ODBC数据库分解数据源名称）
2. 加载任何需要的驱动。
3. 使驱动程序与数据库进行通讯。某些功能，如列出当前所有数据源，仅在驱动管理工具中或通过驱动数据库工具来实现）。 ODBC驱动包含特殊的联接到数据库系统的代码，同时还提供了可供驱动管理工具使用的一套功能。
在ODBC需要，而系同中并不存在相应功能的情况下，驱动程序可以执行某些特殊的数据库功能。
驱动程序还可以转换数据类型。

ODBC驱动可以从网络或销售商处获得。

驱动查找网址 http://www.unixodbc.org 这些驱动程序使驱动程序管理器同数据服务器之间的交流变得容易起来。很多用于Linux的ODBC驱动程序都可以从互联网下载，其他驱动程序可以从你的数据库提供商获得。 这是ODBC的主要配置文件。
文件包含有数据源的配置。

文件用于驱动程序管理器从给定的数据源名称来确定诸如驱动程序名称之类的信息。

文件是简单的文本文件，不过是用ODBC配置工具来进行配置。
作为其特征，用户数据源保存在~/.odbc.ini文件中，而系统数据源保存在/etc/odbc.ini文件中。
 这就是你现在正在使用的程序。该程序允许用户较容易地配置ODBC。 跟踪文件 跟踪 跟踪 跟踪程序使你得以创建访问ODBC驱动程序的日志。这对于提供支持，或者进行应用程序调试都是大有裨益的。
你必须以“root”身份来进行设置。 未能为本条目找到驱动程序行 用户DSN 用户数据源配置被保存在你的用户目录中。这样你就得以对数据存取进行配置，而不必具有系统管理员身份。 gODBC配置－添加DSN gODBC配置－应用程序 gODBC配置－配置驱动程序 gODBC配置－驱动程序管理器 gODBC配置－新驱动程序 gODBCC配置－ODBC数据源管理员 http://www.unixodbc.org odbc.ini odbcinst.ini odbcinst.ini包含所有已安装的ODBC驱动程序列表。每个条目也包含该有驱动程序的一些信息，诸如驱动程序的文件名称等。

当某个ODBC驱动程序被安装或者被卸载删除时，会创建一个条目。这可以通过使用ODBC配置或者odbcinst命令工具来完成。 unixODBC由以下组件构成

－驱动程序管理器
－图形用户界面数据管理器
－图形用户界面配置
－若干驱动程序及驱动程序配置数据库
－驱动程序代码模板
－驱动程序配置代码模板
－ODBCINST数据库
－odbcinst（用于安装脚本的命令行工具）
－INI数据库
－LOG数据库
－LST数据库
－TRE数据库
－SQI数据库
－isql（用于SQL的命令行工具）

所有代码均基于GPL及LGPL许可文件发布。
 