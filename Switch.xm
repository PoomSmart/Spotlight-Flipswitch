#import <Flipswitch/FSSwitchDataSource.h>
#import <Flipswitch/FSSwitchPanel.h>
#import "Header.h"

@interface SpotlightToggleSwitch : NSObject <FSSwitchDataSource>
@end

@implementation SpotlightToggleSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier {
    Boolean keyExist;
    Boolean enabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
    if (!keyExist)
        return FSSwitchStateOn;
    return enabled ? FSSwitchStateOff : FSSwitchStateOn;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier {
    if (newState == FSSwitchStateIndeterminate)
        return;
    CFBooleanRef disabled = newState == FSSwitchStateOn ? kCFBooleanFalse : kCFBooleanTrue;
#if !__LP64__
    if (isiOS7Up) {
#endif
    [(SBSearchViewController *)[%c(SBSearchViewController) sharedInstance] dismiss];
    [(SBSearchGesture *)[%c(SBSearchGesture) sharedInstance] sf_setScrollViewEnabled:disabled != kCFBooleanTrue];
#if !__LP64__
} else {
    if (newState == FSSwitchStateOff && [(SBIconController *)[%c(SBIconController) sharedInstance] isShowingSearch])
        [(SBIconController *)[%c(SBIconController) sharedInstance] scrollToIconListAtIndex:0 animate:YES];
}
#endif
    CFPreferencesSetAppValue(kSpotlightToggleKey, disabled, kSpringBoard);
    CFPreferencesAppSynchronize(kSpringBoard);
}

@end
