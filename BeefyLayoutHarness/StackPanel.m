#import "StackPanel.h"

@interface StackPanel ()
- (CGFloat)initialOffset;

- (CGRect)buildLayoutRectWithOffset:(CGFloat)offset andSize:(CGSize)size;
@end

@implementation StackPanel

@synthesize isReversed = isReversed_;
@synthesize orientation = orientation_;

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat offset = [self initialOffset];
    for (UIView *subview in self.subviews) {
        CGSize size = subview.bounds.size;
        CGFloat subviewSizeOffset = [self fetchSizeOffset:size];

        if (!isReversed_) {
            subview.frame = [self buildLayoutRectWithOffset:offset andSize:size];
            offset += subviewSizeOffset;
        } else {
            offset -= subviewSizeOffset;
            subview.frame = [self buildLayoutRectWithOffset:offset andSize:size];
        }
    }
}

- (CGFloat)fetchSizeOffset:(CGSize)size {
    CGFloat sizeOffset = 0;
    if (orientation_ == Vertical) {
        sizeOffset = size.height;
    } else if (orientation_ == Horizontal) {
        sizeOffset = size.width;
    }
    return sizeOffset ;
}

- (CGFloat)initialOffset {
    CGFloat offset = 0;
    if (isReversed_ && orientation_ == Vertical) {
        offset = self.bounds.size.height;
    } else if (isReversed_ && orientation_ == Horizontal) {
        offset = self.bounds.size.width;
    }
    return offset;
}

- (CGRect)buildLayoutRectWithOffset:(CGFloat)offset andSize:(CGSize)size {
    CGRect rect;
    if (orientation_ == Vertical) {
        rect = CGRectMake(0, offset, size.width, size.height);
    } else if (orientation_ == Horizontal) {
        rect = CGRectMake(offset, 0, size.width, size.height);
    }
    return rect;
}

@end
