//
//  UIButton+ClickBlock.h
//  HMTagTextView
//
//  Created by 郝贺明 on 2020/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ActionBlock)(void);
@interface UIButton (ClickBlock)
 
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block;
 
@end

NS_ASSUME_NONNULL_END
