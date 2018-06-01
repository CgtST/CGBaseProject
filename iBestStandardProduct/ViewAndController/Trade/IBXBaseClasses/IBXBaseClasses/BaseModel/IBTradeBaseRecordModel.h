//
//  IBTradeBaseRecordModel.h
//  iBestProduct
//
//  Created by xboker on 2017/7/6.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "QNBaseHttpClient.h"
#import "IBTradeLoginModle.h"

@protocol IBTradeBaseRecordModeldelegate <NSObject>
@required
- (void)ibGetSystemDateSuccessWithDate:(NSDate *)date withDateStr:(NSString *)dateStr;
- (void)ibGetSystemDateFailedWithInfor:(NSString *)infor shouldPop:(BOOL)shouldPop;


@end


@interface IBTradeBaseRecordModel : QNBaseHttpClient
@property (nonatomic, weak) id<IBTradeBaseRecordModeldelegate>delegate;

/**
 获取交易柜台的系统时间

 @param view 占位view
 @param loginModel 登录信息模型
 */
- (void)getSystemDateActionWithView:(UIView *)view withLoginModel:(IBTradeLoginModle *)loginModel;


@end
