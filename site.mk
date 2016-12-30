GLUON_SITE_PACKAGES := \
gluon-mesh-batman-adv-15 \
gluon-alfred \
gluon-respondd \
gluon-autoupdater \
gluon-config-mode-autoupdater \
gluon-config-mode-contact-info \
gluon-config-mode-core \
gluon-config-mode-geo-location \
gluon-config-mode-hostname \
gluon-config-mode-mesh-vpn \
gluon-ebtables-filter-multicast \
gluon-ebtables-filter-ra-dhcp \
gluon-ebtables-segment-mld \
gluon-luci-admin \
gluon-luci-autoupdater \
gluon-luci-portconfig \
gluon-luci-wifi-config \
gluon-luci-private-wifi \
gluon-luci-node-role \
gluon-mesh-vpn-fastd \
gluon-radvd \
gluon-setup-mode \
gluon-status-page \
haveged \
iptables \
iwinfo \
gluon-radv-filterd \
tecff-ath9k-broken-wifi-workaround \
ffmwu-beta-to-testing

ifeq ($(GLUON_TARGET),x86-generic)
	GLUON_SITE_PACKAGES := $(GLUON_SITE_PACKAGES) \
	kmod-usb-core \
	kmod-usb2 \
	kmod-usb-hid \
	kmod-usb-net \
	kmod-usb-net-asix
endif
ifeq ($(GLUON_TARGET),x86-64)
	GLUON_SITE_PACKAGES := $(GLUON_SITE_PACKAGES) \
	kmod-usb-core \
	kmod-usb2 \
	kmod-usb-hid \
	kmod-usb-net \
	kmod-usb-net-asix
endif

GLUON_REGION ?= eu

GLUON_ATH10K_MESH ?= ibss

DEFAULT_GLUON_RELEASE := 2016.3~$(shell date '+%Y%m%d')

# Allow overriding the release number from the command line
GLUON_RELEASE ?= $(DEFAULT_GLUON_RELEASE)

GLUON_PRIORITY ?= 0

GLUON_LANGS ?= en de fr
