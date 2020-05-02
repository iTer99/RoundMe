THEOS_DEVICE_IP = 192.168.1.1

FINALPACKAGE = 1

export ARCHS = arm64 arm64e

TWEAK_NAME = RoundMe
RoundMe_FILES = Tweak.xm

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
