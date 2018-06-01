//
//  IBCustomDragView.h
//  iBestProduct
//  一个展示大幅文字, 可以拖动的view, 没有计算高度, 使用时选择枚举值进行区分
//  Created by xboker on 2017/7/8.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfrimBlock)(BOOL confirm);
typedef void(^CancelBlock)(BOOL confirm);

typedef NS_ENUM(NSInteger, CustomDragViewType)  {
    ///交易登录时弹出的风险提示框--默认的情况
    CustomDragViewTypeTradeLogin = 0,
    //外汇登录时提示安全须知
    CustomDragViewTypeFX_Login,
    //贵金属登录时提示安全须知
    CustomDragViewTypePM_Login,
    
    
};

@interface IBCustomDragView : UIView



/**
 显示一个可以拖动的展示大篇幅View

 @param type 枚举区分类型
 @param confirm 点击确定回调
 @param cancel 点击取消回调
 */
+ (void)showDragViewWithType:(CustomDragViewType)type withConfirm:(ConfrimBlock)confirm withCancel:(CancelBlock)cancel;



/**
 隐藏可拖动View
 */
+ (void)hideCustomDragView;




@end
