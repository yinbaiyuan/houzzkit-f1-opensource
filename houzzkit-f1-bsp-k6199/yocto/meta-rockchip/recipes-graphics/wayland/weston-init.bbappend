PACKAGECONFIG:append = " no-idle-timeout"

do_install:append() {
	sed -i 's@WantedBy=graphical@WantedBy=multi-user@' ${D}${systemd_system_unitdir}/weston.service
}
