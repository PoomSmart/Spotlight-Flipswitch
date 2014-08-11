#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
#import "Common.h"

@interface SpotlightToggleSwitch : NSObject <FSSwitchDataSource>
@end

@implementation SpotlightToggleSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	Boolean keyExist;
	Boolean enabled = CFPreferencesGetAppBooleanValue((CFStringRef)kSpotlightToggleKey, kSpringBoard, &keyExist);
	if (!keyExist)
		return FSSwitchStateOn;
	return enabled ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	CFPreferencesSetAppValue((CFStringRef)kSpotlightToggleKey, newState == FSSwitchStateOn ? kCFBooleanTrue : kCFBooleanFalse, kSpringBoard);
	CFPreferencesAppSynchronize(kSpringBoard);
}

@end