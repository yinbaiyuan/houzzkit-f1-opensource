do_install:append () {
	sed -i '$a PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"' ${D}/etc/environment
}
