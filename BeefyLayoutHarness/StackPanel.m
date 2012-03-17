#import <CoreGraphics/CoreGraphics.h>
#import "StackPanel.h"

@implementation StackPanel

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat yOffset = 0;
    for (UIView *subview in self.subviews) {
        CGSize size = subview.bounds.size;
        subview.frame = CGRectMake(0, yOffset, size.width, size.height);
        yOffset += size.height;
    }
}

@end
