��    f      L  �   |      �  ?   �  C   �  K   %	  J   q	  =   �	  <   �	  <   7
  <   t
  @   �
  $   �
  )     1   A  1   s  /   �     �  3   �  F   #  7   j  (   �  B   �  B        Q     b  �   |  �   2  !   �  !   �  1     �   @  �   �     �  (   �  |   �  M   l  v   �  �   1  '   �     �        3   ,     `  &   �     �     �  &   �  '   �  4     y   S     �     �  $   �  $        A     `  "   |     �  3   �  F   �     1     F     d     �  /   �  /   �  &   �          4  &   F  *   m  0   �  !   �  ,   �  +        D     W  '   t  "   �     �  $   �  #   �     #     7     Q  .   b     �     �     �  #   �  ,   �  !   )     K  (   X  "   �  %   �     �  #   �  '     %   6  *   \     �  '   �    �  /   �  -      -   .  -   \  *   �  *   �  '   �  *     -   3  &   a  3   �  5   �  0   �  3   #      W   -   n   /   �   6   �   2   !  \   6!  \   �!     �!     �!  �   "  �   �"     �#     �#  D   �#  �   $  �   �$      �%  9   �%  �   �%  Y   p&  q   �&  �   <'  !   �'     �'     (  1   #(     U(     q(     �(     �(  #   �(  #   �(  2   �(  ^   1)     �)     �)     �)     �)     �)     *     1*     O*  -   o*  2   �*     �*     �*     �*     +  %   (+  %   N+  .   t+     �+     �+     �+     �+  <   
,  $   G,  /   l,  "   �,     �,     �,  (   �,     -     --     B-     `-     �-     �-     �-  4   �-     �-     .     ".     ?.     [.     z.     �.  &   �.  "   �.  (   �.  %   /     </     \/     |/  7   �/     �/  "   �/         '   *             X           D          0      .           "   Y   C   A                        Q         c   	   (       !           T   M   K   8             \       2   1   P          3   @   E              [                  b   +   ?   O      G   _       H   =   J           ,   R   U   B   I         -   )   f   ^                  N   d                   /          S   6   &      7   L   :   F   4   Z   a   ;   >   9              V   %   5   e   $                 ]   #       
       <          W   `    Authentication failed because a tls-unique CB was not provided. Authentication failed because the anonymous token was not provided. Authentication failed because the authentication identity was not provided. Authentication failed because the authorization identity was not provided. Authentication failed because the host name was not provided. Authentication failed because the passcode was not provided. Authentication failed because the password was not provided. Authentication failed because the pin code was not provided. Authentication failed because the service name was not provided. Base 64 coding error in SASL library Base64 encoded application data to send:
 Callback failed to provide OPENID20 redirect URL. Callback failed to provide SAML20 IdP identifier. Callback failed to provide SAML20 redirect URL. Cannot find mechanism...
 Client authentication finished (server trusted)...
 Client-side functionality not available in library (application error) Could not prepare internationalized (non-ASCII) string. Enter application data (EOF to finish):
 Enter base64 authentication data from client (press RET if none):
 Enter base64 authentication data from server (press RET if none):
 Enter password:  Error authenticating user GSSAPI error acquiring credentials in gss_acquire_cred() in SASL library.  This is most likely due to not having the proper Kerberos key available in /etc/krb5.keytab on the server. GSSAPI error creating a display name denoting the client in gss_display_name() in SASL library.  This is probably because the client supplied bad data. GSSAPI error decapsulating token. GSSAPI error encapsulating token. GSSAPI error getting OID for SASL mechanism name. GSSAPI error in client while negotiating security context in gss_init_sec_context() in SASL library.  This is most likely due insufficient credentials or malicious interactions. GSSAPI error in server while negotiating security context in gss_accept_sec_context() in SASL library.  This is most likely due insufficient credentials or malicious interactions. GSSAPI error releasing OID set. GSSAPI error testing for OID in OID set. GSSAPI error while decrypting or decoding data in gss_unwrap() in SASL library.  This is most likely due to data corruption. GSSAPI error while encrypting or encoding data in gss_wrap() in SASL library. GSSAPI library could not deallocate memory in gss_release_buffer() in SASL library.  This is a serious internal error. GSSAPI library could not understand a peer name in gss_import_name() in SASL library.  This is most likely due to incorrect service and/or hostnames. GnuTLS global initialization failed: %s GnuTLS handshake failed: %s GnuTLS initialization failed: %s Input list of SASL mechanisms supported by server:
 Input list of SASL mechanisms:
 Integrity error in application payload Libgsasl success Libgsasl unknown error Low-level crypto error in SASL library Memory allocation error in SASL library No callback specified by caller (application error). Other entity requested integrity or confidentiality protection in GSSAPI mechanism but this is currently not implemented. Output from client:
 Output from server:
 SASL mechanism called too many times SASL mechanism could not parse input SASL mechanism needs more data SASL record too large: %zu
 SecurID needs additional passcode. SecurID needs new pin. Server authentication finished (client trusted)...
 Server-side functionality not available in library (application error) Session finished...
 TLS X.509 Certificate %u: %s
 TLS X.509 Verification: %s
 TLS session info: %s
 This client supports the following mechanisms:
 This server supports the following mechanisms:
 Try `%s --help' for more information.
 Unknown SASL mechanism Using mechanism:
 allocating X.509 GnuTLS credential: %s allocating anonymous GnuTLS credential: %s cannot guess SASL profile (try --smtp or --imap) cannot use both --smtp and --imap cannot use both --starttls and --no-starttls could not verify server certificate (rc=%u) encoding error: %s error listing mechanisms: %s error: could not parse server data:
%s
 getting channel binding failed: %s initialization failure: %s iteration count must be positive: %d loading X.509 GnuTLS credential: %s mechanism error: %s mechanism unavailable: %s missing argument need both --x509-cert-file and --x509-key-file no X.509 CAs found no X.509 CAs found: %s required --mechanism missing server certificate has been revoked server certificate hasn't got a known issuer server certificate is not trusted server error setting GnuTLS cipher priority (%s): %s
 setting GnuTLS defaults failed: %s setting GnuTLS server name failed: %s setting GnuTLS system trust: %s setting X.509 GnuTLS credential: %s setting anonymous GnuTLS credential: %s terminating GnuTLS session failed: %s unsupported --mechanism for --mkpasswd: %s verifying peer certificate: %s warning: server did not return a token
 Project-Id-Version: gsasl 2.0.0
Report-Msgid-Bugs-To: bug-gsasl@gnu.org
PO-Revision-Date: 2024-04-03 15:13+0000
Last-Translator: Boyuan Yang <073plan@gmail.com>
Language-Team: Chinese (simplified) <i18n-zh@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Launchpad-Export-Date: 2025-01-30 19:30+0000
X-Generator: Launchpad (build b13dacce4a364151a813e3cdd6940bbff676214a)
Language: zh_CN
X-Bugs: Report translation errors to the Language-Team address.
 验证失败，因为未提供 tls-unique CB。 验证失败，因为未提供匿名标记。 验证失败，因为未提供身份验证。 验证失败，因为未提供身份授权。 验证失败，因为未提供主机名。 验证失败，因为未提供 passcode。 验证失败，因为未提供密码。 验证失败，因为未提供 pin code。 验证失败，因为未提供服务名称。 SASL 库中出现 Base 64 编码错误 要发送的 Base64 编码的应用程序数据：
 回调失败，无法提供 OPENID20 重定向 URL。 回调失败，无法提供 SAML20 IdP 编号。 回调失败，无法提供 SAML20 重定向 URL。 找不到机制……
 客户端认证完成(服务器可信)……
 客户端功能在库中不可用(程序错误) 无法生成国际化的(非 ACSII 码的)字符串。 输入应用程序数据(用 EOF 结束输入)：
 输入客户端发送的 base64 编码的应用程序数据(如果没有，请按回车)：
 输入服务器发送的 base64 编码的应用程序数据(如果没有，请按回车)：
 输入密码:  验证用户时发生错误 进行 SASL 库中 gss_acquire_cred() 函数中的请求证书操作时发生了 GSSAPI 错误。这极有可能是由于在服务器的 /etc/krb5.keytab 中没有合适的 Kerberos 密钥可用造成的。 进行 SASL 库中 gss_display_name() 函数中的创建表示客户端的显示名时发生了GSSAPI 错误。这可能是因为客户端提供了错误的数据。 GSSAPI 解包标识时出错。 GSSAPI 封包标识时出错。 GSSAPI 获取 SASL 机制名称的 OID（对象标识）时出错。 当与 SASL 库中 gss_init_sec_context() 函数中的文本进行安全协商时客户端发生了GSSAPI 错误。这极有可能是由不受信任的证书或恶意会话造成的。 当与 SASL 库中 gss_accept_sec_context() 函数中的文本进行安全协商时服务器端发生了GSSAPI 错误。这极有可能是由不受信任的证书或恶意会话造成的。 GSSAPI 释放 OID位时出错。 GSSAPI 测试 OID位的 OID（对象标识）时出错。 当解密或解码 SASL 库中 gss_unwrap() 函数中的数据时发生了 GSSAPI 错误。这极有可能是由数据损坏造成的。 当加密或编码 SASL 库中 gss_wrap() 函数中的数据时发生了 GSSAPI 错误。 GSSAPI 库无法回收 SASL 库中 gss_release_buffer() 函数所占的内存。这是个严重的内部错误。 GSSAPI 库无法解析 SASL 库中 gss_import_name() 函数中的端点名称。这极有可能是由不正确的服务或主机名造成的。 GnuTLS 全局初始化失败：%s GnuTLS 握手失败：%s GnuTLS 初始化失败：%s 服务器所支持的 SASL 机制输入列表：
 SASL 机制输入列表：
 程序中出现完整性错误 Libgsasl 成功 Libgsasl 未知错误 SASL 库中出现低级加密错误 SASL 库中出现内存分配错误 调用函数未指定回调机制(程序错误)。 其它信息要求在 GSSAP 中提供完整性或私密性保护机制，但目前未实现。 客户端的输出：
 服务器的输出：
 调用 SASL 机制次数太多 SASL 机制无法解析输入 SASL 机制需要更多数据 SASL 记录太大: %zu
 SecurID 需要附加密码。 SecurID 需要新的 pin 值。 服务器认证完成(客户端可信)……
 服务器端功能在库中不可用(程序错误) 会话结束...
 TLS X.509 证书 %u: %s
 TLS X.509 验证：%s
 TLS 会话信息：%s
 这个客户端支持以下机制：
 这个服务器支持以下机制：
 尝试‘%s --help’以获得更多信息。
 未知的 SASL 机制 使用机制：
 分配 X.509 GnuTLS 证书：%s 分配匿名 GnuTLS 证书：%s 无法猜测 SASL 配置文件（尝试 --smtp 或 --imap） 不能同时使用 --smtp 和 --imap 不能同时使用 --starttls 和 --no-starttls 无法验证服务器证书(rc=%u) 编码错误：%s 列出机制时出错：%s 错误: 无法解析服务器数据:
%s
 绑定通道失败：%s 初始化失败：%s 迭代计数必须为正：%d 载入 X.509 GnuTLS 证书：%s 机制错误：%s 机制不可用：%s 缺少参数 既需要 --x509-cert-file 也需要 --x509-key-file 找不到 X.509 CA 证书 找不到 X.509 CA 证书：%s 必需的 --mechanism 缺失 服务器证书已被吊销 服务器证书发行者未知 服务器证书不可信 服务器错误 设定 GnuTLS 密钥优先级(%s): %s
 设定 GnuTLS 默认值失败：%s 设定 GnuTLS 服务器名称失败：%s 设定 GnuTLS 系统信任失败：%s 设定 X.509 GnuTLS 证书：%s 设定匿名 GnuTLS 证书：%s 终止 GnuTLS 会话失败：%s 用于 --mkpassword 的不受支持的 --mechanism：%s 验证节点证书：%s 警告：服务器未返回令牌
 