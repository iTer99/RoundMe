include $(THEOS)/makefiles/common.mk

export ARCHS = arm64 arm64e

BUNDLE_NAME = RoundMe
RoundMe_FILES = RMRootListController.m
RoundMe_INSTALL_PATH = /Library/PreferenceBundles
RoundMe_FRAMEWORKS = UIKit
RoundMe_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RoundMe.plist$(ECHO_END)
