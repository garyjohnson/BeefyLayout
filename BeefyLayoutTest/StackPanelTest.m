#import <CoreGraphics/CoreGraphics.h>
#import "Kiwi.h"
#import "StackPanel.h"

SPEC_BEGIN(StackPanelSpec)

        describe(@"StackPanel", ^{
            context(@"when given a single view", ^{

                __block UIView *childView;
                __block StackPanel *stackPanel;

                beforeEach(^{
                    childView = [[[UIView alloc] init] autorelease];
                    childView.frame = CGRectMake(20, 20, 400, 200);
                    stackPanel = [[[StackPanel alloc] init] autorelease];
                    [stackPanel addSubview:childView];
                });

                it(@"lays out subview at origin", ^{
                    [stackPanel layoutSubviews];

                    [[theValue(childView.frame.origin.x) should] equal:theValue(0)];
                    [[theValue(childView.frame.origin.y) should] equal:theValue(0)];
                });

                it(@"maintins original size of subview", ^{
                    [stackPanel layoutSubviews];

                    [[theValue(childView.frame.size.height) should] equal:theValue(200)];
                    [[theValue(childView.frame.size.width) should] equal:theValue(400)];
                });
            });

            context(@"when given multiple views", ^{
                __block UIView *childView1;
                __block UIView *childView2;
                __block UIView *childView3;
                __block StackPanel *stackPanel;

                beforeEach(^{
                    childView1 = [[[UIView alloc] init] autorelease];
                    childView1.frame = CGRectMake(20, 20, 400, 200);
                    childView2 = [[[UIView alloc] init] autorelease];
                    childView2.frame = CGRectMake(90, 20, 400, 200);
                    childView3 = [[[UIView alloc] init] autorelease];
                    childView3.frame = CGRectMake(20, 10, 400, 200);
                    stackPanel = [[[StackPanel alloc] init] autorelease];

                    [stackPanel addSubview:childView1];
                    [stackPanel addSubview:childView2];
                    [stackPanel addSubview:childView3];
                });

                it(@"lays out subviews at X origin", ^{
                    [stackPanel layoutSubviews];

                    for(UIView *view in stackPanel.subviews) {
                        [[theValue(view.frame.origin.x) should] equal:theValue(0)];
                    }
                });

                it(@"stacks each child below previous one", ^{
                    [stackPanel layoutSubviews];

                    CGFloat yOffset = 0;
                    for(UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                        yOffset += frame.size.height;
                    }
                });
            });
        });

SPEC_END