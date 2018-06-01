//
//  IBTradeBaseRecordViewController.h
//  iBestProduct
//  查询交易历史记录类的交易controller基类; 多了一个从系统获取到的时间-
//  Created by xboker on 2017/7/6.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBTradeBaseViewController.h"
#import "IBTradeBaseRecordModel.h"


@interface IBTradeBaseRecordViewController : IBTradeBaseViewController

@property (nonatomic, strong) NSDate    *m_SystemDate;
@property (nonatomic, strong) NSString  *m_SystemDateStr;

@property (nonatomic, strong) IBTradeBaseRecordModel    *m_GetDateRequest;

//- (void)getSystemDateAction;

@end
