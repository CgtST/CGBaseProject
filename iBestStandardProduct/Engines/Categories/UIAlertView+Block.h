//
//  UIAlertView+Block.h
//  APlan
//
//  Created by ven on 14-9-10.
//  Copyright (c) 2014年 jingling. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Block)

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;

@end
