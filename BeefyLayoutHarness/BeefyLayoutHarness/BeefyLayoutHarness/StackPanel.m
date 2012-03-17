#import "StackPanel.h"

@implementation StackPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    float yPosition = 0;
    for (UIView *subview in self.subviews) {
        if (!subview.hidden) {
            CGSize size = subview.bounds.size;
            subview.frame = CGRectMake(0, yPosition, size.width, size.height);
            yPosition += size.height;
        }
    }
}

@end
