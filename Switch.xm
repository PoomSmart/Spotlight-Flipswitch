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
		return FSSwitchStateOff;
	return enabled ? FSSwitchStateOff : FSSwitchStateOn;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	CFPreferencesSetAppValue((CFStringRef)kSpotlightToggleKey, newState == FSSwitchStateOff ? kCFBooleanTrue : kCFBooleanFalse, kSpringBoard);
	CFPreferencesAppSynchronize(kSpringBoard);
}

@end
