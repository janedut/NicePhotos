//#import "PerfectSettings13.h"

static NSString *bundleIdentifier = @"com.aohuiliu.nicephotos";
static NSMutableDictionary *settings;

static BOOL enabled;
%group settings
%hook PUUserTransformView

- (void)_setPreferredMaximumZoomScale: (double)arg
{
    %orig(9999);
}

%end

%hook PUDeletePhotosActionController

- (BOOL)shouldSkipDeleteConfirmation
{
    return YES;
}

%end


%end



static void refreshPrefs() {
	CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if(keyList) {
		settings = (NSMutableDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)bundleIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
		CFRelease(keyList);
	} else {
		settings = nil;
	}
	if (!settings) {
		settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", bundleIdentifier]];
	}
  enabled = ( [settings objectForKey:@"enabled"] ? [[settings objectForKey:@"enabled"] boolValue] : NO );

}
static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  refreshPrefs();
}


%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) PreferencesChangedCallback, (CFStringRef)[NSString stringWithFormat:@"%@/prefschanged", bundleIdentifier], NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  refreshPrefs();
	if (enabled == YES) %init(settings);

}
