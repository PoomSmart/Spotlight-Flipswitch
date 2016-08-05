DEBUG = 0
PACKAGE_VERSION = 0.0.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SpotlightToggle
SpotlightToggle_FILES = Tweak.xm Switch.xm
SpotlightToggle_FRAMEWORKS = UIKit
SpotlightToggle_LIBRARIES = flipswitch substrate
SpotlightToggle_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk