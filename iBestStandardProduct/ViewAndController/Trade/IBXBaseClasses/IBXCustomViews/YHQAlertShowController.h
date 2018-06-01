//
//  YHQAlertShowController.h
//  Yihaodais
//
//  Created by Money on 16/7/18.
//  Copyright © 2016年 gf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHQAlertShowController : UIAlertController

/**
 *  系统的AlertView不合适，需要自定议的alertView,文字靠左对齐，行距为2
 *
 *  @param title          提示头
 *  @param message        提示信息
 *  @param preferredStyle 显示样式
 *
 *  @return YHQAlertShowController
 */
+ (instancetype)alertShowControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

/**
 *  系统的AlertView不合适，需要自定议的alertView
 *
 *  @param title             提示头
 *  @param attributedMessage 提示信息的属性字符串
 *  @param preferredStyle    显示样式
 *
 *  @return YHQAlertShowController
 */
+ (instancetype)alertShowControllerWithTitle:(NSString *)title AttributedMessage:(NSAttributedString *)attributedMessage preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
