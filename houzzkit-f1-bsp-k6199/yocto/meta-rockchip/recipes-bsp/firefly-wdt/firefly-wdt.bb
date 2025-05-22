DESCRIPTION = "Firefly watch dog Service"

LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
	file://firefly-wdt-ctl \
	file://firefly-wdt.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "firefly-wdt.service"

do_install() {
	install -d ${D}${bindir}
	install -d ${D}${systemd_system_unitdir}
	install -m 0755 ${WORKDIR}/firefly-wdt-ctl ${D}${bindir}/
	install -m 644 ${WORKDIR}/firefly-wdt.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += " \
	${systemd_system_unitdir}/firefly-wdt.service \
	${bindir}/firefly-wdt-ctl \
"

SYSTEMD_AUTO_ENABLE = "enable"
