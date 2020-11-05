//
//  UITextField+CS.m
//  Dory
//
//  Created by 郝贺明 on 2020/10/24.
//  Copyright © 2020 Chasing. All rights reserved.
//

#import "UITextField+CS.h"
#import <objc/runtime.h>
NSString * const CSTextFieldDidDeleteBackwardNotification = @"zf.Dory.chasing.textfield.did.notification";
@implementation UITextField (CS)
+ (void)load {
    //交换方法
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(cs_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)cs_deleteBackward {
    [self cs_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <CSTextFieldDelegate> delegate  = (id<CSTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:CSTextFieldDidDeleteBackwardNotification object:self];
}
@end
