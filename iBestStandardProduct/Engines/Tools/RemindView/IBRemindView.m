//
//  IBRemindView.m
//  Created by ibest on 15/7/22.
//  Copyright (c) 2015年 ibest All rights reserved.
//

#import "IBRemindView.h"
#import <MBProgressHUD.h>

#define kHiddenDelayTime 3.0

@implementation IBRemindView

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.detailsLabelFont = hud.labelFont;
        hud.detailsLabelColor = hud.labelColor;
        hud.detailsLabelText = text;
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = NO;
        
        // 1秒之后再消失
        [hud hide:YES afterDelay:kHiddenDelayTime];
    });
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view {
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view {
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (void)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        //已经在显示的话, 剔除
        BOOL have = NO;
        for (id obj in [view subviews]) {
            if ([obj isKindOfClass:[MBProgressHUD class]]) {
                MBProgressHUD *huddd = (MBProgressHUD *)obj;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [huddd hide:YES];
                });
                [huddd removeFromSuperview];
                break;
            }
        }
        for (id obj in [view subviews]) {
            if ([obj isKindOfClass:[MBProgressHUD class]]) {
                have = YES;
                break;
            }
        }
        if (have) {
            return ;
        }
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.detailsLabelFont = hud.labelFont;
        hud.detailsLabelColor = hud.labelColor;
        hud.detailsLabelText = message;
        hud.mode = MBProgressHUDModeText;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = NO;
        //    // YES代表需要蒙版效果
        //    hud.dimBackground = YES;
        [hud hide:YES afterDelay:kHiddenDelayTime];
    });
}

+ (void)showMessagForTrade:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        //已经在显示的话, 剔除
        BOOL have = NO;
        for (id obj in [view subviews]) {
            if ([obj isKindOfClass:[MBProgressHUD class]]) {
                MBProgressHUD *huddd = (MBProgressHUD *)obj;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [huddd hide:YES];
                });
                [huddd removeFromSuperview];
                break;
            }
        }
        for (id obj in [view subviews]) {
            if ([obj isKindOfClass:[MBProgressHUD class]]) {
                have = YES;
                break;
            }
        }
        if (have) {
            return ;
        }
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.detailsLabelFont = hud.labelFont;
        hud.detailsLabelColor = hud.labelColor;
        hud.detailsLabelText = message;
        hud.mode = MBProgressHUDModeText;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = NO;
        //    // YES代表需要蒙版效果
        //    hud.dimBackground = YES;
        [hud hide:YES afterDelay:4];
    });
}
@end
