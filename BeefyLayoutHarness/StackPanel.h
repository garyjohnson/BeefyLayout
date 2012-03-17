#import <UIKit/UIKit.h>

typedef enum {
    Vertical,
    Horizontal
} Orientation;

@interface StackPanel : UIView

@property (nonatomic, readwrite) BOOL isReversed;
@property (nonatomic, readwrite) Orientation orientation;

@end
