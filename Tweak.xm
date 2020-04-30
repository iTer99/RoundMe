@interface _UIRootWindow : UIView
@property (setter=_setContinuousCornerRadius:, nonatomic) double _continuousCornerRadius;
@end

@interface FBSystemService : NSObject
  +(id)sharedInstance;
  -(void)exitAndRelaunch:(BOOL)arg1;
@end

static BOOL isEnabled = YES;
static int RoundedCorner = 10;
static int RoundedSwitcher = 10;

%hook _UIRootWindow
-(void)layoutSubviews
{
    if (isEnabled)
    {
    self.clipsToBounds = YES;
    self._continuousCornerRadius = RoundedCorner;
    return;
    }
    %orig;
}
%end

%hook UITraitCollection
- (CGFloat)displayCornerRadius
{
    if (isEnabled)
    {
	  return RoundedSwitcher;
    }
    return %orig;
}
%end

static void reloadSettings() {
  static CFStringRef RoundMePrefsKey = CFSTR("com.iter99.roundme");
  CFPreferencesAppSynchronize(RoundMePrefsKey);

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"EnabledTW", RoundMePrefsKey))) {
    isEnabled = [(id)CFPreferencesCopyAppValue((CFStringRef)@"EnabledTW", RoundMePrefsKey) boolValue];
  }

  if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"Corner", RoundMePrefsKey))) {
    RoundedCorner = [(id)CFPreferencesCopyAppValue((CFStringRef)@"Corner", RoundMePrefsKey) intValue];
  }

    if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"Switcher", RoundMePrefsKey))) {
    RoundedSwitcher = [(id)CFPreferencesCopyAppValue((CFStringRef)@"Switcher", RoundMePrefsKey) intValue];
  }
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
  [[%c(FBSystemService) sharedInstance] exitAndRelaunch:YES];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.iter99.roundme.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.iter99.roundme.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  reloadSettings();
}
