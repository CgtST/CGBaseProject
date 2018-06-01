//
//  IBCustomLoginView.h
//  QNApp
//  通用的弹出登录的自定义View
//  Created by xboker on 2017/4/10.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomLoginViewType) {
    CustomLoginViewTypeObligate = 0,///预留项!!!永远不能设置这个选项
    CustomLoginViewTypeLogin,///普通的交易登录
    CustomLoginViewTypeResignNewBuyStock,///撤回新股申购
    CustomLoginViewTypeNewBuyStockLogin,///新股申购时---交易登录
};


typedef void(^SuccessBlock)(NSString *infor,BOOL isLogin);
typedef void(^FaildBlock) (NSString *infor, BOOL pop);


@interface IBCustomLoginView : UIView
#pragma mark    普通登录时调用时弹出的方法
///使用此方法, 请先询问用法!!!!!!不然会崩溃
+ (void)showCustomViewWithBlock:(SuccessBlock)successBlock withBlock:(FaildBlock)failBlock ;

#pragma mark    撤回新股申购时调用的方法
+ (void)showCustomViewWithBlock:(SuccessBlock)successBlock withBlock:(FaildBlock)failBlock withType:(CustomLoginViewType)type withInfor:(NSString *)infor;




@end

