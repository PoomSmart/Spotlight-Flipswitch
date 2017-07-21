#if !__LP64__

#import "Header.h"

static BOOL noHookOffset = YES;

%hook SBSearchController

- (void)_updateTableContents {
    noHookOffset = YES;
    %orig;
    noHookOffset = NO;
}

%end

%hook SBIconScrollView

- (void)setContentOffset: (CGPoint)offset {
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

- (void)_showSearchKeyboardIfNecessary: (id)arg1 {
    Boolean keyExist;
    Boolean disabled = CFPreferencesGetAppBooleanValue(kSpotlightToggleKey, kSpringBoard, &keyExist);
    if (keyExist && disabled)
        return;
    %orig;
}

%end

%ctor {
    %init;
}

#endif
