//
//  IBRemindView.h
//  Created by ibest on 15/7/22.
//  Copyright (c) 2015年 ibest All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  公用提醒类
 */
@interface IBRemindView : NSObject
/**
 *  显示错误提醒
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示成功提醒
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示普通提醒
 */
+ (void)showMessag:(NSString *)message toView:(UIView *)view;

+ (void)showMessagForTrade:(NSString *)message toView:(UIView *)view;
@end
