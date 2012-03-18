#import "StackPanel.h"
#import "UIView+BeefyLayout.h"

@interface StackPanel ()
- (void)layoutSubviewsHorizontallyReversed;

- (CGFloat)availableHeightForEachFillSubview;


- (void)layoutSubviewsVertically;

- (void)layoutSubviewsVerticallyReversed;

- (void)layoutSubviewsHorizontally;
@end

@implementation StackPanel

@synthesize isReversed = isReversed_;
@synthesize orientation = orientation_;

- (void)layoutSubviews {
    [super layoutSubviews];

    if (orientation_ == Vertical && !isReversed_) {
        [self layoutSubviewsVertically];
    } else if (orientation_ == Vertical && isReversed_) {
        [self layoutSubviewsVerticallyReversed];
    } else if (orientation_ == Horizontal && !isReversed_) {
        [self layoutSubviewsHorizontally];
    } else if (orientation_ == Horizontal && isReversed_) {
        [self layoutSubviewsHorizontallyReversed];
    }
}

- (void)layoutSubviewsVertically {
    CGFloat availableHeight = [self availableHeightForEachFillSubview];
    CGFloat yOffset = 0;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        CGFloat subviewHeight = subviewSize.height;
        if (subview.fillAvailableSpace) {
            subviewHeight = availableHeight;
        }

        subview.frame = CGRectMake(subview.marginLeft, yOffset + subview.marginTop, subviewSize.width, subviewHeight);
        yOffset += subviewHeight + subview.marginTop + subview.marginBottom;
    }
}

- (void)layoutSubviewsVerticallyReversed {
    CGFloat availableHeight = [self availableHeightForEachFillSubview];
    CGFloat yOffset = self.bounds.size.height;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        CGFloat subviewHeight = subviewSize.height;
        if (subview.fillAvailableSpace) {
            subviewHeight = availableHeight;
        }
        yOffset -= (subviewHeight + subview.marginBottom);
        subview.frame = CGRectMake(subview.marginLeft, yOffset, subviewSize.width, subviewHeight);
        yOffset -= subview.marginTop;
    }
}

- (void)layoutSubviewsHorizontally {
    CGFloat xOffset = 0;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        subview.frame = CGRectMake(xOffset + subview.marginLeft, subview.marginTop, subviewSize.width, subviewSize.height);
        xOffset += subviewSize.width + subview.marginLeft + subview.marginRight;
    }
}

- (void)layoutSubviewsHorizontallyReversed {
    CGFloat xOffset = self.bounds.size.width;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        xOffset -= subviewSize.width + subview.marginRight;
        subview.frame = CGRectMake(xOffset, subview.marginTop, subviewSize.width, subviewSize.height);
        xOffset -= subview.marginLeft;
    }
}

- (CGFloat)availableHeightForEachFillSubview {
    CGFloat availableHeight = self.bounds.size.height;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        if (!subview.fillAvailableSpace) {
            availableHeight -= subviewSize.height;
        }
        availableHeight -= (subview.marginBottom + subview.marginTop);
    }
    return availableHeight;
}

@end
