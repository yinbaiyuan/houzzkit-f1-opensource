KERNEL_RELEASE              ?= "NULL"
RKBIN_RELEASE               ?= "NULL"
TOOLS_RELEASE               ?= "NULL"
UBOOT_RELEASE               ?= "NULL"
RKWIFIBT_RELEASE            ?= "NULL"
ALSAS_CONFIG_RELEASE        ?= "NULL"
GSTREAMER_ROCKCHIP_RELEASE  ?= "NULL"
MPP_RELEASE                 ?= "NULL"
CAMERA_ENGINE_RKISP         ?= "NULL"
CAMERA_ENGINE_RKAIQ         ?= "NULL"
LINUX_RGA                   ?= "NULL"
LIBMALI                     ?= "NULL"


RK_WIFIBT_RRECOMMENDS = " \
	rkwifibt-firmware \
	brcm-tools \
"

# firefly
IMAGE_INSTALL:append = " \
	rktoolkit \
	bash-completion \
	net-tools \
	alsa-utils \
	vim \
	v4l-utils \
	iptables \
	rfkill \
	usbutils \
	clinfo \
	htop \
	rsync \
	netcat \
	stress \
	stressapptest \
	figlet \
	parted \
	ca-certificates \
	curl \
	file \
	python3 \
	upower \
	eject \
	fbset \
	unzip \
	zip \
	logrotate \
	ethtool \
	iperf3 \
	i2c-tools \
	psmisc \
	procps \
	strace \
	ldd \
	glibc-utils \
	sudo \
	sed \
	rockchip-npu \
	firefly-wdt \
	syslog-ng \
"

#IMAGE_INSTALL:append = " locale-base-zh-cn locale-base-zh-tw"

# install glibc locale
#GLIBC_GENERATE_LOCALES = "en_US.UTF-8 zh_CN.UTF-8 zh_TW.UTF-8"

# install locale-base 
#IMAGE_LINGUAS = "en-us zh-cn zh-tw"


INHERIT += "extrausers"
EXTRA_USERS_PARAMS += " \
	usermod -p '\$1\$N173a03l\$lVFl5NjiEQlx/ojFt6omS/' root; \
	useradd -p '\$1\$N173a03l\$lVFl5NjiEQlx/ojFt6omS/' -G wheel,users -d /home/firefly -m firefly; \
	usermod -aG sudo firefly; \
"
