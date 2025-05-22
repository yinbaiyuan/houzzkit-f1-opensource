FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://NetworkManager.conf "

do_install:append () {
	install -Dm 0644 ${WORKDIR}/NetworkManager.conf ${D}${sysconfdir}/NetworkManager/
	ln -sf NetworkManager.service ${D}${systemd_system_unitdir}/network-manager.service
}
