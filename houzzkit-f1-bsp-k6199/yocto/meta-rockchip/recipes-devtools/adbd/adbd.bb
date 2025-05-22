DESCRIPTION = "Firefly adb Service"

LICENSE = "CLOSED"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
	file://adbd \
	file://adbd.sh \
	file://adbd.service \
	file://.usb_config \
	file://umtprd.conf \
	file://usbdevice \
	file://61-usbdevice.rules \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "adbd.service"

RDEPENDS:${PN} = "bash"

do_install:append() {
	install -d ${D}${bindir}
	install -d ${D}${sysconfdir}/init.d
	install -d ${D}${sysconfdir}/umtprd
	install -d ${D}${systemd_system_unitdir}
	install -d ${D}${sysconfdir}/udev/rules.d

	install -m 0755 ${WORKDIR}/adbd.sh ${D}${sysconfdir}/init.d/adbd.sh
	install -m 644 ${WORKDIR}/adbd.service ${D}${systemd_system_unitdir}
	install -m 0755 ${WORKDIR}/.usb_config ${D}${sysconfdir}/init.d/
	install -m 0755 ${WORKDIR}/umtprd.conf ${D}${sysconfdir}/umtprd/
	install -m 0755 ${WORKDIR}/adbd ${D}${bindir}
	install -m 0755 ${WORKDIR}/usbdevice ${D}${bindir}
	install -m 0644 ${WORKDIR}/61-usbdevice.rules ${D}${sysconfdir}/udev/rules.d/
}

FILES:${PN}: += " \
	${sysconfdir}/init.d/adbd.sh \
	${systemd_system_unitdir}/adbd.service \
	${sysconfdir}/init.d/.usb_config \
	${sysconfdir}/umtprd/umtprd.conf \
	${bindir}/adbd \
	${bindir}/usbdevice \
	${sysconfdir}/udev/rules.d/61-usbdevice.rules \
"

SYSTEMD_AUTO_ENABLE = "enable"
