#import <Foundation/Foundation.h>

@interface UIView (BeefyLayout)

@property (nonatomic, readwrite) CGFloat marginLeft;
@property (nonatomic, readwrite) CGFloat marginRight;
@property (nonatomic, readwrite) CGFloat marginTop;
@property (nonatomic, readwrite) CGFloat marginBottom;
@property (nonatomic, readwrite) BOOL fillAvailableSpace;

@end