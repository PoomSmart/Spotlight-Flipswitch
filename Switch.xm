#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"

CFStringRef const kSpotlightToggleKey = CFSTR("SBNoSpotlight");
CFStringRef const kSpringBoard = CFSTR("com.apple.springboard");

@interface SBIconController : NSObject
+ (id)sharedInstance;
- (BOOL)isShowingSearch;
- (void)scrollToIconListAtIndex:(unsigned)index animate:(BOOL)animated;
@end

@interface SBIconScrollView : UIScrollView
@end

@interface SBSearchScrollView : UIScrollView
@end

@interface SBSearchGesture : NSObject
@end

@interface SBSearchViewController : NSObject
+ (id)sharedInstance;
- (void)dismiss;
@end

@interface SBSearchGesture (Addition)
- (void)sf_setScrollViewEnabled:(BOOL)enabled;
@end

@interface SpotlightToggleSwitch : NSObject <FSSwitchDataSource>
@end

@implementation SpotlightToggleSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	Boolean keyExist;
	Boolean enabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (!keyExist)
		return FSSwitchStateOn;
	return enabled ? FSSwitchStateOff : FSSwitchStateOn;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	CFBooleanRef disabled = newState == FSSwitchStateOn ? kCFBooleanFalse : kCFBooleanTrue;
	if (isiOS7Up) {
		BOOL enabled = disabled != kCFBooleanTrue;
		[[%c(SBSearchViewController) sharedInstance] dismiss];
		[[%c(SBSearchGesture) sharedInstance] sf_setScrollViewEnabled:enabled];
	} else {
		if (newState == FSSwitchStateOff) {
			if ([[%c(SBIconController) sharedInstance] isShowingSearch])
				[[%c(SBIconController) sharedInstance] scrollToIconListAtIndex:0 animate:YES];
		}
	}
	CFPreferencesSetAppValue(kSpotlightToggleKey, disabled, kSpringBoard);
	CFPreferencesAppSynchronize(kSpringBoard);
}

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

%group iOS7

%hook SBSearchGesture

%new
- (void)sf_setScrollViewEnabled:(BOOL)enabled
{
	[MSHookIvar<SBSearchScrollView *>(self, "_scrollView") setScrollEnabled:enabled];
}

- (void)_updateScrollingEnabled
{
	%orig;
	Boolean keyExist;
	Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (!keyExist)
		return;
	if (![[%c(SBIconController) sharedInstance] isEditing])
		[self sf_setScrollViewEnabled:!disabled];
}

%end

%end

%ctor
{
	if (isiOS7Up) {
		%init(iOS7);
	}
	else {
		%init(iOS456);
	}
}