PACKAGE_VERSION = 0.0.3
TARGET = iphone:clang:latest:5.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SpotlightToggle
SpotlightToggle_FILES = TweakLegacy.xm TweakModern.xm Switch.xm
SpotlightToggle_FRAMEWORKS = UIKit
SpotlightToggle_EXTRA_FRAMEWORKS = CydiaSubstrate
SpotlightToggle_LIBRARIES = flipswitch
SpotlightToggle_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk
