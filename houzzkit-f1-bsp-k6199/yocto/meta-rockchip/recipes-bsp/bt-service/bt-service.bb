DESCRIPTION = "Firefly bt Service"

LICENSE = "LICENSE.rockchip"
LIC_FILES_CHKSUM = "file://${RKBASE}/licenses/LICENSE.rockchip;md5=d63890e209bf038f44e708bbb13e4ed9"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS:append = " rfkill"

SRC_URI = " \
	file://50-bluetooth.rules \
	file://bt_uart.cfg \
	file://bt-attach.service \
	file://bt-attach \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "bt-attach.service"

RDEPENDS:${PN} = "bash"

do_install:append() {
	install -d ${D}${bindir}
	install -d ${D}${systemd_system_unitdir}
	install -d ${D}/lib/udev/rules.d

	install -m 0755 ${WORKDIR}/bt-attach ${D}${bindir}
	install -m 0755 ${WORKDIR}/bt_uart.cfg ${D}${bindir}
	install -m 0644 ${WORKDIR}/bt-attach.service ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/50-bluetooth.rules ${D}/lib/udev/rules.d
}

FILES:${PN}: += " \
	${bindir}/bt-attach \
	${bindir}/bt_uart.cfg \
	${systemd_system_unitdir}/bt-attach.service \
	${D}/lib/udev/rules.d/50-bluetooth.rules \
"
