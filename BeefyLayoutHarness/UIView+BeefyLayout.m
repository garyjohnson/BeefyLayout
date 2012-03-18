#import <objc/runtime.h>
#import "UIView+BeefyLayout.h"

@implementation UIView (BeefyLayout)

static char MARGIN_BOTTOM_KEY;
static char MARGIN_TOP_KEY;
static char MARGIN_RIGHT_KEY;
static char MARGIN_LEFT_KEY;

@dynamic marginBottom;
@dynamic marginTop;
@dynamic marginRight;
@dynamic marginLeft;

- (CGFloat)marginBottom {
    return [((NSNumber*)objc_getAssociatedObject(self, &MARGIN_BOTTOM_KEY)) floatValue];
}

- (void)setMarginBottom:(CGFloat)margin {
    objc_setAssociatedObject(self, &MARGIN_BOTTOM_KEY, [NSNumber numberWithFloat:margin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)marginTop {
    return [((NSNumber*)objc_getAssociatedObject(self, &MARGIN_TOP_KEY)) floatValue];
}

- (void)setMarginTop:(CGFloat)margin {
    objc_setAssociatedObject(self, &MARGIN_TOP_KEY, [NSNumber numberWithFloat:margin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)marginRight {
    return [((NSNumber*)objc_getAssociatedObject(self, &MARGIN_RIGHT_KEY)) floatValue];
}

- (void)setMarginRight:(CGFloat)margin {
    objc_setAssociatedObject(self, &MARGIN_RIGHT_KEY, [NSNumber numberWithFloat:margin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)marginLeft {
    return [((NSNumber*)objc_getAssociatedObject(self, &MARGIN_LEFT_KEY)) floatValue];
}

- (void)setMarginLeft:(CGFloat)margin {
    objc_setAssociatedObject(self, &MARGIN_LEFT_KEY, [NSNumber numberWithFloat:margin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end