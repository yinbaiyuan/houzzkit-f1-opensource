LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

RDEPENDS:${PN} = "util-linux gptfdisk parted"

SRC_URI = " \
	file://resize-helper \
	file://resize-helper.service \
"

do_install () {
	install -d ${D}${sbindir}
	install -d ${D}${systemd_system_unitdir}
	install -m 0755 ${WORKDIR}/resize-helper ${D}${sbindir}/
	install -m 0644 ${WORKDIR}/resize-helper.service ${D}${systemd_system_unitdir}/
}

inherit systemd

SYSTEMD_SERVICE:${PN} = "resize-helper.service"

FILES:${PN} += "${sbindir}/resize-helper ${systemd_system_unitdir}/resize-helper.service"
