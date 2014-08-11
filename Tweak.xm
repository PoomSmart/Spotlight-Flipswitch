#import "Common.h"

@interface SBIconScrollView : UIScrollView
@end

%group iOS456

static BOOL noHookOffset = YES;

%hook SBSearchController

- (void)_updateTableContents
{
	noHookOffset = YES;
	%orig;
	noHookOffset = NO;
}

%end

%hook SBIconScrollView

- (void)setContentOffset:(CGPoint)offset
{
	Boolean keyExist;
	Boolean enabled = !CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && enabled && !noHookOffset) {
		if (offset.x <= self.frame.size.width) {
			%orig(CGPointMake(self.frame.size.width, offset.y));
			return;
		}
	}
	%orig;
}

%end

%hook SBIconController

- (void)_showSearchKeyboardIfNecessary:(id)arg1
{
	Boolean keyExist;
	Boolean enabled = !CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && enabled)
		return;
	%orig;
}

%end

%end

%group iOS7

%hook SBSearchScrollView

- (BOOL)_canScrollY
{
	Boolean keyExist;
	Boolean enabled = !CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (!keyExist)
		return %orig;
	return enabled;
}

%end

%end

%ctor
{
	if (kCFCoreFoundationVersionNumber > 793.00) {
		%init(iOS7);
	} else {
		%init(iOS456);
	}
}