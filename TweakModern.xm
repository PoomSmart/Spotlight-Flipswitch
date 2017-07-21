#import "Header.h"

%hook SBSearchGesture

%new
- (void)sf_setScrollViewEnabled: (BOOL)enabled {
    MSHookIvar<SBSearchScrollView *>(self, "_scrollView").scrollEnabled = enabled;
}

- (void)_updateScrollingEnabled {
    %orig;
    Boolean keyExist;
    Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
    if (!keyExist)
        return;
    if (![(SBIconController *)[%c(SBIconController) sharedInstance] isEditing])
        [self sf_setScrollViewEnabled:!disabled];
}

%end

%group iOS9Up

%hook SBSpotlightSettings

- (BOOL)enableSpotlightOnMinusPage {
    Boolean keyExist;
    Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
    if (keyExist && disabled)
        return NO;
    return %orig;
}

%end

%end

%ctor {
    if (isiOS9Up) {
        %init(iOS9Up);
    }
    %init;
}
