//
//  UIButton+ClickBlock.m
//  HMTagTextView
//
//  Created by 郝贺明 on 2020/10/29.
//

#import <objc/runtime.h>
#import "UIButton+ClickBlock.h"

@implementation UIButton (ClickBlock)

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block
{
    if(!event)
        event=UIControlEventTouchUpInside;
    objc_setAssociatedObject(self, &"myBlock", block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(blockEvent:) forControlEvents:event];
    
}
-(void)blockEvent:(UIButton *)sender
{
    ActionBlock block=objc_getAssociatedObject(self, &"myBlock");
    if(block)
    {
        block();
    }
}
@end
