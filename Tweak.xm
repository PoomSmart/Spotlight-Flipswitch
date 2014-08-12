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
	Boolean disabled = CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && disabled && !noHookOffset) {
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
	Boolean disabled = CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && disabled)
		return;
	%orig;
}

%end

%end

%group iOS7

/*%hook SBSearchScrollView

- (BOOL)_canScrollY
{
	Boolean keyExist;
	Boolean disabled = CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (!keyExist)
		return %orig;
	return !disabled;
}

%end*/

%hook SBSearchViewController

- (void)searchGesture:(id)gesture changedPercentComplete:(float)percent
{
	Boolean keyExist;
	Boolean disabled = CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && disabled)
		return;
	%orig;
}

- (void)searchGesture:(id)gesture completedShowing:(BOOL)show
{
	Boolean keyExist;
	Boolean disabled = CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && disabled)
		return;
	%orig;
}

%end

%hook SBSearchGesture

- (void)scrollViewDidScroll:(id)arg1
{
	Boolean keyExist;
	Boolean disabled = CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && disabled)
		return;
	%orig;
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