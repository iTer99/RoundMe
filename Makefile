FINALPACKAGE = 1

export ARCHS = arm64

TWEAK_NAME = RoundMe
RoundMe_FILES = Tweak.xm

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
