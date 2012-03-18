#import "StackPanel.h"
#import "UIView+BeefyLayout.h"

@interface StackPanel ()
- (void)layoutSubviewsHorizontallyReversed;
- (CGFloat)availableHeightForEachFillSubview;

- (CGFloat)availableWidthForEachFillSubview;

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
    CGFloat availableWidth = [self availableWidthForEachFillSubview];
    CGFloat xOffset = 0;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        CGFloat subviewWidth = subviewSize.width;
        if (subview.fillAvailableSpace) {
            subviewWidth = availableWidth;
        }
        subview.frame = CGRectMake(xOffset + subview.marginLeft, subview.marginTop, subviewWidth, subviewSize.height);
        xOffset += subviewWidth + subview.marginLeft + subview.marginRight;
    }
}

- (void)layoutSubviewsHorizontallyReversed {
    CGFloat availableWidth = [self availableWidthForEachFillSubview];
    CGFloat xOffset = self.bounds.size.width;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        CGFloat subviewWidth = subviewSize.width;
        if (subview.fillAvailableSpace) {
            subviewWidth = availableWidth;
        }
        xOffset -= subviewWidth + subview.marginRight;
        subview.frame = CGRectMake(xOffset, subview.marginTop, subviewWidth, subviewSize.height);
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

- (CGFloat)availableWidthForEachFillSubview {
    CGFloat availableWidth = self.bounds.size.width;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        if (!subview.fillAvailableSpace) {
            availableWidth -= subviewSize.width;
        }
        availableWidth -= (subview.marginLeft + subview.marginRight);
    }
    return availableWidth;
}

@end
