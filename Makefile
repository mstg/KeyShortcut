ARCHS = armv7 armv7s arm64
TARGET = iphone:latest:7.0

include theos/makefiles/common.mk

TWEAK_NAME = KeyShortcut
KeyShortcut_FILES = KeyShortcut.x
KeyShortcut_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
