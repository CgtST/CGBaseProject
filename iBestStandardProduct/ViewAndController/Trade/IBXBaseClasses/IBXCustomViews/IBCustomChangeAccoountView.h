//
//  IBCustomChangeAccoountView.h
//  QNApp
//  一个自定义的弹出切换登录账号的View--其中cell----55高度
//  Created by xboker on 2017/4/14.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlock) (NSString *content, NSInteger index, NSString *account);
typedef void(^HideCallBack) ();


typedef NS_ENUM(NSInteger, ChangeAccountType) {
    ///布局从导航条下方开始显示
    ChangeAccountTypeFromNavBar = 0,
    ///布局从导航条下方+50处开始显示
    ChangeAccountTypeNotFromNavBar
};



@interface IBCustomChangeAccoountView : UIView

+ (void)hideCustomChangeAccoountViewWithBlock:(CallBackBlock)block;
+ (void)showCustomChangeAccoountViewWithBlock:(CallBackBlock)block withOffet:(BOOL)offset withData:(NSMutableArray *)data withHideCallBack:(HideCallBack)hide withType:(ChangeAccountType)type ;

@end
