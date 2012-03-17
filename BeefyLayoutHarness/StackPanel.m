#import "StackPanel.h"

@implementation StackPanel

@synthesize isReversed = isReversed_;
@synthesize orientation = orientation_;

- (void)layoutSubviews {
    [super layoutSubviews];

    if (orientation_ == Vertical) {
        if (!isReversed_) {
            CGFloat yOffset = 0;
            for (UIView *subview in self.subviews) {
                CGSize size = subview.bounds.size;
                subview.frame = CGRectMake(0, yOffset, size.width, size.height);
                yOffset += size.height;
            }
        } else {
            CGFloat yOffset = self.bounds.size.height;
            for (UIView *subview in self.subviews) {
                CGSize size = subview.bounds.size;
                yOffset -= size.height;
                subview.frame = CGRectMake(0, yOffset, size.width, size.height);
            }
        }
    } else if(orientation_ == Horizontal) {
        for (UIView *subview in self.subviews) {
            CGSize size = subview.bounds.size;
            subview.frame = CGRectMake(0, 0, size.width, size.height);
        }
    }
}

@end
