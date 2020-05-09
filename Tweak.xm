#import <QuartzCore/QuartzCore.h>

@interface _UIRootWindow : UIView
@property (setter=_setContinuousCornerRadius:, nonatomic) double _continuousCornerRadius;
@end

@interface FBSystemService : NSObject
  +(id)sharedInstance;
  -(void)exitAndRelaunch:(BOOL)arg1;
@end

@interface MTMaterialLayer : CALayer
@end

@interface MTMaterialView : UIView
@end

static BOOL isEnabled = YES;
static int RoundedCorner = 10;
static int RoundedSwitcher = 10; 
static int RoundedWidget = 10;
static int RoundedNotification = 10;
static int RoundedPlater = 10;
static int RoundedDock = 10;

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

%hook MTMaterialView
-(id)_materialLayer 
{
  if (isEnabled)
  {
	MTMaterialLayer *orig = %orig;
  
  if ([self.superview class] == objc_getClass("WGWidgetPlatterView"))
		{
			orig.cornerRadius = RoundedWidget;
		}
	
  if ([self.superview class] == objc_getClass("NCNotificationShortLookView"))
		{
			orig.cornerRadius = RoundedNotification;
		}   

  if ([self.superview class] == objc_getClass("PLPlatterView"))
		{
			orig.cornerRadius = RoundedPlater;
		}
		
  if (([self.superview class] == objc_getClass("SBDockView")) || ([self.superview class] == objc_getClass("SBFloatingDockView")))
		{
			orig.cornerRadius = RoundedDock;
		}
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
  
    if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"Widget", RoundMePrefsKey))) {
    RoundedWidget = [(id)CFPreferencesCopyAppValue((CFStringRef)@"Widget", RoundMePrefsKey) intValue];
  }
  
    if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"Notification", RoundMePrefsKey))) {
    RoundedNotification = [(id)CFPreferencesCopyAppValue((CFStringRef)@"Notification", RoundMePrefsKey) intValue];
  }
  
    if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"Platter", RoundMePrefsKey))) {
    RoundedPlater = [(id)CFPreferencesCopyAppValue((CFStringRef)@"Platter", RoundMePrefsKey) intValue];
  }
  
    if (CFBridgingRelease(CFPreferencesCopyAppValue((CFStringRef)@"Dock", RoundMePrefsKey))) {
    RoundedDock = [(id)CFPreferencesCopyAppValue((CFStringRef)@"Dock", RoundMePrefsKey) intValue];
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
