//
//  IBCustomOrderView.h
//  QNApp
//  下单时如果时隔夜单, 则需要弹出提示
//  Created by xboker on 2017/5/24.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmOrder)(void);
typedef void(^CancelOrder)(void);



typedef NS_ENUM(NSInteger, ConfirmOrderType) {
    ///GTN时段的大幅提示语
    ConfirmOrderTypeGTN = 0,
    ///GTN前面的拆单确认提示框__A股
    ConfirmOrderTypeConfirmStock_A,
    //GTN前面的拆单确认提示框__港股
    ConfirmOrderTypeConfirmStock_HK,
    ///动用孖展能力提示
    ConfirmOrderTypeUseMarginInfor,
    ///当日第二笔资金提取时的提示
    ConfirmOrderTypeMoneyOutInfor,
    ///当日第二笔账户转账时的提示
    ConfirmOrderTypeMoneyExchangeInfor,
    ///当条件盘下单时需要检测是否弹窗
    ConfirmOrderTypeConditionOrderInfor,
    ///获取系统时间失败
    ConfirmOrderTypeGetSystemDateDailed,
    ///禁止用户转账的提示, 普通
    ConfirmOrderTypeCanNotAccountTransfer,
    ///禁止用户转账, 专业账户
    ConfirmOrderTypeCanNotAccountTransfer_Profession,
    ///禁止用户资金提取, 专业账户
    ConfirmOrderTypeCanNotWithDraw_Profession,
    ///禁止用户资金提取的提示
    ConfirmOrderTypeCanNotWithDraw,
    ///不是交易时间段
    ConfirmOrderTypeIsNotDealTime,
    ///SBU账户特别提示
    ConfirmOrderTypeIs_SBU_Account,
    ///重新设置交易密码时点击后退时的提示
    ConfirmOrderTypeResetPSWCancleInfor,
    ///忘记交易账号提示证件格式时的提示
    ConfirmOrderTypeTFAIDCardInfor,
    ///交易登录重发验证码超过6次后弹窗提示让用户重新开始走流程
    ConfirmOrderTypeTLResendVerifyCodeExcess,
    ///665交易登录后有一种情况可以让用户点击保留密码
    ConfirmOrderType_665Login_CanKeepPSW,
    ///665交易登录后,弹窗必须修改密码
    ConfirmOrderType_665Login_CanNotKeepPSW,
    ///665交易登录  ISSUED状态后,弹窗必须修改密码
    ConfirmOrderType_665Login_ISSUED_Status,
    ///快速注册或绑定_665交易登录后有一种情况可以让用户点击保留密码
    ConfirmOrderType_665Login_CanKeepPSW_FastRegistOrBind,
    ///快速注册或绑定_665交易登录后,弹窗必须修改密码
    ConfirmOrderType_665Login_CanNotKeepPSW_FastRegistOrBind,
    ///快速注册或绑定_665交易登录  ISSUED状态后,弹窗必须修改密码
    ConfirmOrderType_665Login_ISSUED_Status_FastRegistOrBind,
    ///外汇或者贵金属登录时密码错误的提示框
    ConfirmOrderType_FX_PMLogin_InvalidPSW,
    ///外汇或者贵金属开户时提示没有登录的界面
    ConfirmOrderType_FX_PMOpenAccount_HaveNoLogin,
    ///外汇或者贵金属开户时提示补充资料
    ConfirmOrderType_FX_PMOpenAccount_UpdateInformation,
    ///获取相机的权限
    ConfirmOrderType_CameraLimit,
    ///获取相册的权限
    ConfirmOrderType_AlbumLimit,
    
};



@interface IBCustomOrderView : UIView

///确定,取消都要捕获
+ (void)showCustomOrderViewWithBlock:(ConfirmOrder)confirmBlock withCancel:(CancelOrder)cancelBlock withType:(ConfirmOrderType)type;
///只捕获确定点击事件
+ (void)showCustomOrderViewWithBlock:(ConfirmOrder)confirmBlock withType:(ConfirmOrderType)type;
+ (void)hideViewAction;


@end

