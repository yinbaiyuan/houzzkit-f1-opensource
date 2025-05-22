FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://interfaces_for_networkmanager "

do_install:append () {
	install -m 0644 ${WORKDIR}/interfaces_for_networkmanager ${D}${sysconfdir}/network/interfaces
}
