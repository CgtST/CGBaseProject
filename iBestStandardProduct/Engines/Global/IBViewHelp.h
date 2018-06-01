//
//  IBViewHelp.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 xboker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>

@interface IBViewHelp : NSObject

#pragma mark - UIBarButtonItem
//转换位置
+(CGRect)convert2WindowRect:(CGRect)rect fromView:( UIView*)fromView;

#pragma mark - UIBarButtonItem
//返回
+( UIBarButtonItem*)getCustomBackButtonItem:( id)target action:( SEL)action;

//导航栏左边按钮
+( UIBarButtonItem*)getButtonItem:( id)target action:( SEL)action Image:( UIImage*)image Title:( NSString*)titleStr;

+ ( UIBarButtonItem*)getButtonItem:( id)target action:( SEL)action Image:( UIImage*)image Title:( NSString*)titleStr font:( UIFont *)font;

//导航栏右侧的图标
+( UIBarButtonItem*)getRightButtonItem:( id)target action:( SEL)action Image:( UIImage*)image Title:( NSString*)titleStr;

+( UIImage *)imageWithColor:( UIColor *)color size:(CGSize)size;


#pragma mark -Button Label

/**
 创建Button
 */
+( UIButton *)createButtonFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize;


/**
 创建label
 */
+(UILabel *)createLabelFrame:(CGRect)frame textcolor:(UIColor *)textcolor textFontSize:(CGFloat)fontsize;


/**
 创建分割线
 */
+(UIView *)creatSepLineFrame:(CGRect )rect;




@end
