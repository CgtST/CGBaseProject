//
//  IBXMenuChooseView.h
//  QNApp
//  一个弹出选择菜单--弹出在window上.位于
//  Created by xboker on 2017/3/31.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ShowBlcok) (NSIndexPath *path, id content);
typedef NS_ENUM(NSInteger, CustomShowType) {
    ///资金提取时的账户
    CustomShowTypeWithDrawAccount = 0,
    ///资金提取时的市场
    CustomShowTypeWithDrawMarket,
    ///资金提取时的收款银行
    CustomShowTypeWithDrawBank,
    
    ///账户转账时的转出账户
    CustomShowTypeTransferOutAccount,
    ///账户转账时的转出市场
    CustomShowTypeTransferOutMarket,
    ///账户转账时的转入账户
    CustomShowTypeTransferInAccount,
    ///账户转账时的转入市场
    CustomShowTypeTransferInMarket,
    ///股票转仓界面弹出持仓列表进行选择
    CustomShowTypeStockTransfer,
    ///外汇选择品种进行交易
    CustomShowTypeFX_Deal_ChooseType,
    ///外汇选择交易选择条件期限
    CustomShowTypeFX_Deal_ConditionLimit,
    ///外汇选择交易选择订单期限
    CustomShowTypeFX_Deal_OrderLimit,
    ///贵金属选择品种进行交易
    CustomShowTypePM_Deal_ChooseType,
    
};




@interface IBXMenuChooseView : UIView

/**
 直接类调用, 弹出一个下拉菜单------简单的的

 @param title 这个菜单的标题
 @param data 展示菜单的数据源
 @param block 回调的block<回调点击的index和实际内容>
 */
//+ (void)showMenuWithTitle:(NSString *)title withData:(NSArray *)data withBlock:(ShowBlcok)block ;






/**
 直接类调用, 弹出一个下拉菜单--定制, 必须传入枚举值
 
 @param title 这个菜单的标题
 @param data 展示菜单的数据源
 @param block 回调的block<回调点击的index和实际内容>
 @param type 显示内容的类型
 */
+ (void)showMenuWithTitle:(NSString *)title withData:(NSArray *)data withBlock:(ShowBlcok)block withType:(CustomShowType)type;



+ (void)hideView;



@end
