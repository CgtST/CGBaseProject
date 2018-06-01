//
//  IBBaseSuccessViewController.h
//  iBestProduct
//
//  Created by xboker on 2017/9/5.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "QNBaseViewController.h"

typedef NS_ENUM(NSUInteger, BaseSuccessViewType) {
    ///重新设置密码成功
    BaseSuccessViewTypeResetPSWSuccess = 0,
    ///转仓转入成功
    BaseSuccessViewTypeStockTransferSuccessIn,
    ///转仓转出成功
    BaseSuccessViewTypeStockTransferSuccessOut,
    ///找回交易账号最后验证邮箱成功提示
    BaseSuccessViewTypeTradeForgetAccountFindSuccess,
};



@interface IBBaseSuccessViewController : QNBaseViewController

@property (nonatomic, assign) BaseSuccessViewType m_Type;

@property (nonatomic, strong) NSString *m_Message;

@end
