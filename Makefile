TARGET := iphone:clang:latest:4.0
ARCHS = armv6 armv7 arm64

include theos/makefiles/common.mk

BUNDLE_NAME = SpotlightToggle
SpotlightToggle_FILES = Switch.xm
SpotlightToggle_FRAMEWORKS = UIKit
SpotlightToggle_LIBRARIES = flipswitch
SpotlightToggle_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk

TWEAK_NAME = SpotlightToggleTweak
SpotlightToggleTweak_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk