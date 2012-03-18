#import <CoreGraphics/CoreGraphics.h>
#import "Kiwi.h"
#import "StackPanel.h"

SPEC_BEGIN(StackPanelSpec)

        describe(@"StackPanel", ^{
                __block StackPanel *stackPanel;
                __block UIView *childView1;
                __block UIView *childView2;
                __block UIView *childView3;

            context(@"when given a single view", ^{

                beforeEach(^{
                    childView1 = [[[UIView alloc] init] autorelease];
                    childView1.frame = CGRectMake(20, 20, 400, 200);
                    stackPanel = [[[StackPanel alloc] init] autorelease];
                    [stackPanel addSubview:childView1];
                });

                it(@"defaults to vertical orientation", ^{
                    [[theValue(stackPanel.orientation) should] equal:theValue(Vertical)];
                });

                it(@"defaults to not being reversed", ^{
                    [[theValue(stackPanel.isReversed) should] equal:theValue(NO)];
                });

                it(@"lays out subview at origin", ^{
                    [stackPanel layoutSubviews];

                    [[theValue(childView1.frame.origin.x) should] equal:theValue(0)];
                    [[theValue(childView1.frame.origin.y) should] equal:theValue(0)];
                });

                it(@"maintins original size of subview", ^{
                    [stackPanel layoutSubviews];

                    [[theValue(childView1.frame.size.height) should] equal:theValue(200)];
                    [[theValue(childView1.frame.size.width) should] equal:theValue(400)];
                });
            });

            context(@"when given multiple views | vertical | not reversed", ^{
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

            context(@"when given multiple views | vertical | reversed", ^{
                beforeEach(^{
                    childView1 = [[[UIView alloc] init] autorelease];
                    childView1.frame = CGRectMake(20, 20, 400, 200);
                    childView2 = [[[UIView alloc] init] autorelease];
                    childView2.frame = CGRectMake(90, 20, 400, 200);
                    childView3 = [[[UIView alloc] init] autorelease];
                    childView3.frame = CGRectMake(20, 10, 400, 200);
                    stackPanel = [[[StackPanel alloc] init] autorelease];
                    stackPanel.frame = CGRectMake(0, 0, 500, 1000);

                    stackPanel.isReversed = YES;

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

                it(@"places the first views bottom against the bottom of the stackpanel", ^{
                   [stackPanel layoutSubviews];

                    UIView *firstView = [stackPanel.subviews objectAtIndex:0];
                    CGPoint origin = firstView.frame.origin;
                    CGSize stackPanelSize = stackPanel.bounds.size;
                    CGFloat expectedOrigin = stackPanelSize.height - firstView.bounds.size.height;
                    [[theValue(origin.y) should] equal:theValue(expectedOrigin)];
                });

                it(@"stacks each child below previous one", ^{
                    [stackPanel layoutSubviews];

                    CGSize stackPanelSize = stackPanel.bounds.size;
                    CGFloat yOffset = stackPanelSize.height;
                    for(UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        yOffset -= frame.size.height;
                        [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                    }
                });
            });

            context(@"when given multiple views | horizontal | not reversed", ^{
                beforeEach(^{
                    childView1 = [[[UIView alloc] init] autorelease];
                    childView1.frame = CGRectMake(20, 20, 400, 200);
                    childView2 = [[[UIView alloc] init] autorelease];
                    childView2.frame = CGRectMake(90, 20, 400, 200);
                    childView3 = [[[UIView alloc] init] autorelease];
                    childView3.frame = CGRectMake(20, 10, 400, 200);
                    stackPanel = [[[StackPanel alloc] init] autorelease];
                    stackPanel.orientation = Horizontal;

                    [stackPanel addSubview:childView1];
                    [stackPanel addSubview:childView2];
                    [stackPanel addSubview:childView3];
                });

                it(@"lays out subviews at Y origin", ^{
                    [stackPanel layoutSubviews];

                    for(UIView *view in stackPanel.subviews) {
                        [[theValue(view.frame.origin.y) should] equal:theValue(0)];
                    }
                });

                it(@"stacks each child to the right of previous one", ^{
                    [stackPanel layoutSubviews];

                    CGSize stackPanelSize = stackPanel.bounds.size;
                    CGFloat xOffset = 0;
                    for(UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                        xOffset += frame.size.width;
                    }
                });
            });

            context(@"when given multiple views | horizontal | reversed", ^{
                beforeEach(^{
                    childView1 = [[[UIView alloc] init] autorelease];
                    childView1.frame = CGRectMake(20, 20, 400, 200);
                    childView2 = [[[UIView alloc] init] autorelease];
                    childView2.frame = CGRectMake(90, 20, 400, 200);
                    childView3 = [[[UIView alloc] init] autorelease];
                    childView3.frame = CGRectMake(20, 10, 400, 200);
                    stackPanel = [[[StackPanel alloc] init] autorelease];
                    stackPanel.orientation = Horizontal;
                    stackPanel.isReversed = YES;

                    [stackPanel addSubview:childView1];
                    [stackPanel addSubview:childView2];
                    [stackPanel addSubview:childView3];
                });

                it(@"lays out subviews at Y origin", ^{
                    [stackPanel layoutSubviews];

                    for(UIView *view in stackPanel.subviews) {
                        [[theValue(view.frame.origin.y) should] equal:theValue(0)];
                    }
                });

                it(@"places the first views right edge against the right edge of the stackpanel", ^{
                    [stackPanel layoutSubviews];

                    UIView *firstView = [stackPanel.subviews objectAtIndex:0];
                    CGPoint origin = firstView.frame.origin;
                    CGSize stackPanelSize = stackPanel.bounds.size;
                    CGFloat expectedOrigin = stackPanelSize.width - firstView.bounds.size.width;
                    [[theValue(origin.x) should] equal:theValue(expectedOrigin)];
                });

                it(@"stacks each child to the left of previous one", ^{
                    [stackPanel layoutSubviews];

                    CGSize stackPanelSize = stackPanel.bounds.size;
                    CGFloat xOffset = stackPanelSize.width;
                    for(UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        xOffset -= frame.size.width;
                        [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                    }
                });
            });
        });

SPEC_END