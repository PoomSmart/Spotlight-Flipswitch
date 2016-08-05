#import "Header.h"

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
	Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
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
	Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && disabled)
		return;
	%orig;
}

%end

%end

%group iOS7Up

%hook SBSearchGesture

%new
- (void)sf_setScrollViewEnabled:(BOOL)enabled
{
	MSHookIvar<SBSearchScrollView *>(self, "_scrollView").scrollEnabled = enabled;
}

- (void)_updateScrollingEnabled
{
	%orig;
	Boolean keyExist;
	Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (!keyExist)
		return;
	if (![(SBIconController *)[%c(SBIconController) sharedInstance] isEditing])
		[self sf_setScrollViewEnabled:!disabled];
}

%end

%end

%group iOS9Up

%hook SBSpotlightSettings

- (BOOL)enableSpotlightOnMinusPage
{
	Boolean keyExist;
	Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (keyExist && disabled)
		return NO;
	return %orig;
}

%end

%end

%ctor
{
	if (isiOS7Up) {
		if (isiOS9Up) {
			%init(iOS9Up);
		}
		%init(iOS7Up);
	}
	else {
		%init(iOS456);
	}
}