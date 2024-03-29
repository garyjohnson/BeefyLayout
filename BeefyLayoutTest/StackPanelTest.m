#import <CoreGraphics/CoreGraphics.h>
#import "Kiwi.h"
#import "StackPanel.h"
#import "UIView+BeefyLayout.h"

StackPanel *aStackPanelWithOneSubview() {
    UIView *childView1 = [[[UIView alloc] init] autorelease];
    childView1.frame = CGRectMake(20, 20, 400, 200);
    StackPanel *stackPanel = [[[StackPanel alloc] init] autorelease];
    [stackPanel addSubview:childView1];
    return stackPanel;
}

StackPanel *aStackPanelWithMultipleSubviews() {
    UIView *childView1 = [[[UIView alloc] init] autorelease];
    childView1.frame = CGRectMake(20, 20, 400, 200);
    UIView *childView2 = [[[UIView alloc] init] autorelease];
    childView2.frame = CGRectMake(90, 20, 400, 200);
    UIView *childView3 = [[[UIView alloc] init] autorelease];
    childView3.frame = CGRectMake(20, 10, 400, 200);
    StackPanel *stackPanel = [[[StackPanel alloc] init] autorelease];
    [stackPanel addSubview:childView1];
    [stackPanel addSubview:childView2];
    [stackPanel addSubview:childView3];
    return stackPanel;
}

SPEC_BEGIN(StackPanelSpec)

        describe(@"StackPanel", ^{
            __block StackPanel *stackPanel;

            context(@"when given a single view", ^{

                beforeEach(^{
                    stackPanel = aStackPanelWithOneSubview();
                });

                it(@"defaults to vertical orientation", ^{
                    [[theValue(stackPanel.orientation) should] equal:theValue(Vertical)];
                });

                it(@"defaults to not being reversed", ^{
                    [[theValue(stackPanel.isReversed) should] equal:theValue(NO)];
                });

                it(@"lays out subview at origin", ^{
                    [stackPanel layoutSubviews];

                    UIView *childView1 = [stackPanel.subviews objectAtIndex:0];
                    [[theValue(childView1.frame.origin.x) should] equal:theValue(0)];
                    [[theValue(childView1.frame.origin.y) should] equal:theValue(0)];
                });

                it(@"maintins original size of subview", ^{
                    [stackPanel layoutSubviews];

                    UIView *childView1 = [stackPanel.subviews objectAtIndex:0];
                    [[theValue(childView1.frame.size.height) should] equal:theValue(200)];
                    [[theValue(childView1.frame.size.width) should] equal:theValue(400)];
                });

                it(@"stretches 'fillAvailableSpace' subview to height of parent", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *subview = [stackPanel.subviews objectAtIndex:0];
                    subview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(subview.frame.size.height) should] equal:theValue(1000)];
                    [[theValue(subview.frame.size.width) should] equal:theValue(400)];
                });
            });

            context(@"when given multiple views | vertical | not reversed", ^{
                beforeEach(^{
                    stackPanel = aStackPanelWithMultipleSubviews();
                });

                it(@"lays out subviews at X origin", ^{
                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
                        [[theValue(view.frame.origin.x) should] equal:theValue(0)];
                    }
                });

                it(@"stacks each child below previous one", ^{
                    [stackPanel layoutSubviews];

                    CGFloat yOffset = 0;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                        yOffset += frame.size.height;
                    }
                });

                it(@"respects left margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginLeft = 20;

                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
                        if (view == secondSubview) {
                            [[theValue(view.frame.origin.x) should] equal:theValue(20)];
                        } else {
                            [[theValue(view.frame.origin.x) should] equal:theValue(0)];
                        }
                    }
                });

                it(@"respects top margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginTop = 20;

                    [stackPanel layoutSubviews];

                    CGFloat yOffset = 0;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset + 20)];
                            yOffset += frame.size.height + 20;
                        } else {
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                            yOffset += frame.size.height;
                        }
                    }
                });

                it(@"respects bottom margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    UIView *thirdSubview = [stackPanel.subviews objectAtIndex:2];
                    secondSubview.marginBottom = 20;

                    [stackPanel layoutSubviews];

                    CGFloat yOffset = 0;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == thirdSubview) {
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset + 20)];
                            yOffset += frame.size.height + 20;
                        } else {
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                            yOffset += frame.size.height;
                        }
                    }
                });

                it(@"stretches 'fillAvailableSpace' subview to height of parent minus height of other subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.height) should] equal:theValue(600)];
                    [[theValue(secondSubview.frame.size.width) should] equal:theValue(400)];
                });

                it(@"lays out subview after 'fillAvailableSpace' subview at correct position", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    UIView *thirdSubview = [stackPanel.subviews objectAtIndex:2];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(thirdSubview.frame.origin.y) should] equal:theValue(800)];
                });

                it(@"takes subview margins into account when stretching 'fillAvailableSpace' subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;
                    for (UIView *view in stackPanel.subviews) {
                        view.marginTop = 5.0f;
                        view.marginBottom = 10.0f;
                    }

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.height) should] equal:theValue(555)];
                });
            });

            context(@"when given multiple views | vertical | reversed", ^{
                beforeEach(^{
                    stackPanel = aStackPanelWithMultipleSubviews();
                    stackPanel.isReversed = YES;
                });

                it(@"lays out subviews at X origin", ^{
                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
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
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        yOffset -= frame.size.height;
                        [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                    }
                });

                it(@"respects left margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginLeft = 20;

                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
                        if (view == secondSubview) {
                            [[theValue(view.frame.origin.x) should] equal:theValue(20)];
                        } else {
                            [[theValue(view.frame.origin.x) should] equal:theValue(0)];
                        }
                    }
                });

                it(@"respects top margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    UIView *thirdSubview = [stackPanel.subviews objectAtIndex:2];
                    secondSubview.marginTop = 20;

                    [stackPanel layoutSubviews];

                    CGFloat yOffset = stackPanel.bounds.size.height;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == thirdSubview) {
                            yOffset -= (frame.size.height + 20);
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                        } else {
                            yOffset -= frame.size.height;
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                        }
                    }
                });

                it(@"respects bottom margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginBottom = 20;

                    [stackPanel layoutSubviews];

                    CGFloat yOffset = 0;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            yOffset -= (frame.size.height + 20);
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                        } else {
                            yOffset -= frame.size.height;
                            [[theValue(frame.origin.y) should] equal:theValue(yOffset)];
                        }
                    }
                });

                it(@"stretches 'fillAvailableSpace' subview to height of parent minus height of other subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.height) should] equal:theValue(600)];
                    [[theValue(secondSubview.frame.size.width) should] equal:theValue(400)];
                });

                it(@"lays out subview after 'fillAvailableSpace' subview at correct position", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    UIView *thirdSubview = [stackPanel.subviews objectAtIndex:2];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(thirdSubview.frame.origin.y) should] equal:theValue(0)];
                });

                it(@"takes subview margins into account when stretching 'fillAvailableSpace' subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;
                    for (UIView *view in stackPanel.subviews) {
                        view.marginTop = 5.0f;
                        view.marginBottom = 10.0f;
                    }

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.height) should] equal:theValue(555)];
                });
            });

            context(@"when given multiple views | horizontal | not reversed", ^{
                beforeEach(^{
                    stackPanel = aStackPanelWithMultipleSubviews();
                    stackPanel.orientation = Horizontal;
                });

                it(@"lays out subviews at Y origin", ^{
                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
                        [[theValue(view.frame.origin.y) should] equal:theValue(0)];
                    }
                });

                it(@"stacks each child to the right of previous one", ^{
                    [stackPanel layoutSubviews];

                    CGFloat xOffset = 0;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                        xOffset += frame.size.width;
                    }
                });

                it(@"respects left margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginLeft = 20;

                    [stackPanel layoutSubviews];

                    CGFloat xOffset = 0;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset + 20)];
                            xOffset += frame.size.width + 20;
                        } else {
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                            xOffset += frame.size.width;
                        }
                    }
                });

                it(@"respects right margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginRight = 20;

                    [stackPanel layoutSubviews];

                    CGFloat xOffset = 0;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                            xOffset += frame.size.width + 20;
                        } else {
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                            xOffset += frame.size.width;
                        }
                    }
                });

                it(@"respects top margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginTop = 20;

                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            [[theValue(frame.origin.y) should] equal:theValue(20)];
                        } else {
                            [[theValue(frame.origin.y) should] equal:theValue(0)];
                        }
                    }
                });

                it(@"stretches 'fillAvailableSpace' subview to width of parent minus widths of other subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.height) should] equal:theValue(200)];
                    [[theValue(secondSubview.frame.size.width) should] equal:theValue(2200)];
                });

                it(@"lays out subview after 'fillAvailableSpace' subview at correct position", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    UIView *thirdSubview = [stackPanel.subviews objectAtIndex:2];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(thirdSubview.frame.origin.x) should] equal:theValue(2600)];
                });

                it(@"takes subview margins into account when stretching 'fillAvailableSpace' subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;
                    for (UIView *view in stackPanel.subviews) {
                        view.marginLeft = 5.0f;
                        view.marginRight = 10.0f;
                    }

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.width) should] equal:theValue(2155)];
                });
            });

            context(@"when given multiple views | horizontal | reversed", ^{
                beforeEach(^{
                    stackPanel = aStackPanelWithMultipleSubviews();
                    stackPanel.orientation = Horizontal;
                    stackPanel.isReversed = YES;
                });

                it(@"lays out subviews at Y origin", ^{
                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
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
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        xOffset -= frame.size.width;
                        [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                    }
                });

                it(@"respects left margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginLeft = 20;

                    [stackPanel layoutSubviews];

                    CGFloat xOffset = stackPanel.bounds.size.width;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            xOffset -= (frame.size.width);
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                            xOffset -= 20;
                        } else {
                            xOffset -= frame.size.width;
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                        }
                    }
                });

                it(@"respects right margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginRight = 20;

                    [stackPanel layoutSubviews];

                    CGFloat xOffset = stackPanel.bounds.size.width;
                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            xOffset -= (frame.size.width + 20);
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                        } else {
                            xOffset -= frame.size.width;
                            [[theValue(frame.origin.x) should] equal:theValue(xOffset)];
                        }
                    }
                });

                it(@"respects top margin on subview", ^{
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.marginTop = 20;

                    [stackPanel layoutSubviews];

                    for (UIView *view in stackPanel.subviews) {
                        CGRect frame = view.frame;
                        if (view == secondSubview) {
                            [[theValue(frame.origin.y) should] equal:theValue(20)];
                        } else {
                            [[theValue(frame.origin.y) should] equal:theValue(0)];
                        }
                    }
                });

                it(@"stretches 'fillAvailableSpace' subview to width of parent minus widths of other subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.height) should] equal:theValue(200)];
                    [[theValue(secondSubview.frame.size.width) should] equal:theValue(2200)];
                });

                it(@"lays out subview after 'fillAvailableSpace' subview at correct position", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    UIView *thirdSubview = [stackPanel.subviews objectAtIndex:2];
                    secondSubview.fillAvailableSpace = YES;

                    [stackPanel layoutSubviews];

                    [[theValue(thirdSubview.frame.origin.x) should] equal:theValue(0)];
                });

                it(@"takes subview margins into account when stretching 'fillAvailableSpace' subviews", ^{
                    stackPanel.frame = CGRectMake(0, 0, 3000, 1000);
                    UIView *secondSubview = [stackPanel.subviews objectAtIndex:1];
                    secondSubview.fillAvailableSpace = YES;
                    for (UIView *view in stackPanel.subviews) {
                        view.marginLeft = 5.0f;
                        view.marginRight = 10.0f;
                    }

                    [stackPanel layoutSubviews];

                    [[theValue(secondSubview.frame.size.width) should] equal:theValue(2155)];
                });
            });
        });

        SPEC_END