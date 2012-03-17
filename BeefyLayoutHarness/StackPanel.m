#import <CoreGraphics/CoreGraphics.h>
#import "StackPanel.h"

@implementation StackPanel

@synthesize isReversed = isReversed_;


- (void)layoutSubviews {
    [super layoutSubviews];

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
}

@end
