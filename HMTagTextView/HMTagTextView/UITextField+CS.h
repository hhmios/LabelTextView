//
//  UITextField+CS.h
//  Dory
//
//  Created by 郝贺明 on 2020/10/24.
//  Copyright © 2020 Chasing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CSTextFieldDelegate <UITextFieldDelegate>
@optional
- (void)textFieldDidDeleteBackward:(UITextField *)textField;
@end
@interface UITextField (CS)
@property (weak, nonatomic) id<CSTextFieldDelegate> delegate;
@end
/**
 *  监听删除按钮
 *  object:UITextField
 */
extern NSString * const WJTextFieldDidDeleteBackwardNotification;

NS_ASSUME_NONNULL_END
