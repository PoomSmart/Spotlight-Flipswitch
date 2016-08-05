#import "../PS.h"

@interface SBIconController : NSObject
+ (SBIconController *)sharedInstance;
- (BOOL)isEditing;
- (BOOL)isShowingSearch;
- (void)scrollToIconListAtIndex:(NSUInteger)index animate:(BOOL)animated;
@end

@interface SBIconScrollView : UIScrollView
@end

@interface SBSearchScrollView : UIScrollView
@end

@interface SBSearchGesture : NSObject
@end

@interface SBSearchViewController : NSObject
+ (SBSearchViewController *)sharedInstance;
- (void)dismiss;
@end

@interface SBSearchGesture (Addition)
- (void)sf_setScrollViewEnabled:(BOOL)enabled;
@end

CFStringRef const kSpotlightToggleKey = CFSTR("SBNoSpotlight");
CFStringRef const kSpringBoard = CFSTR("com.apple.springboard");