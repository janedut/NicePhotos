ARCHS = arm64 arm64e
FINALPACKAGE = 1
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = NicePhotos
NicePhotos_FILES = Tweak.xm
NicePhotos_PRIVATE_FRAMEWORKS = Preferences
NicePhotos_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp NicePhotosPrefs.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NicePhotosPrefs.plist$(ECHO_END)
	$(ECHO_NOTHING)cp -r Resources $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NicePhotosPrefs.Resources$(ECHO_END)
