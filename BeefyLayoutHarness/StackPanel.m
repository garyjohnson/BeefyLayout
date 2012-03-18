#import "StackPanel.h"
#import "UIView+BeefyLayout.h"

@interface StackPanel ()
- (void)layoutSubviewsHorizontallyReversed;

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
    CGFloat yOffset = 0;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        subview.frame = CGRectMake(subview.marginLeft, yOffset + subview.marginTop, subviewSize.width, subviewSize.height);
        yOffset += subviewSize.height + subview.marginTop + subview.marginBottom;
    }
}

- (void)layoutSubviewsVerticallyReversed {
    CGFloat yOffset = self.bounds.size.height;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        yOffset -= subviewSize.height;
        subview.frame = CGRectMake(subview.marginLeft, yOffset, subviewSize.width, subviewSize.height);
        yOffset -= subview.marginTop;
    }
}

- (void)layoutSubviewsHorizontallyReversed {
    CGFloat xOffset = self.bounds.size.width;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        xOffset -= subviewSize.width;
        subview.frame = CGRectMake(xOffset, 0, subviewSize.width, subviewSize.height);
    }
}

- (void)layoutSubviewsHorizontally {
    CGFloat xOffset = 0;
    for (UIView *subview in self.subviews) {
        CGSize subviewSize = subview.bounds.size;
        subview.frame = CGRectMake(xOffset, 0, subviewSize.width, subviewSize.height);
        xOffset += subviewSize.width;
    }
}

@end
