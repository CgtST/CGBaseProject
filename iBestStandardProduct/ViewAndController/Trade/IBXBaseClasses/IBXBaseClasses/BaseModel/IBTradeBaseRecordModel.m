//
//  IBTradeBaseRecordModel.m
//  iBestProduct
//
//  Created by xboker on 2017/7/6.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBTradeBaseRecordModel.h"

@implementation IBTradeBaseRecordModel

-(instancetype)init {
    self = [super initWithBaseURL: IB_SHARE_TRADE_BASE_URL];
    if (self) {
        
    }
    return self;
}


- (void)getSystemDateActionWithView:(UIView *)view withLoginModel:(IBTradeLoginModle *)loginModel {
    if (loginModel == nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginHaveTimeOut object:nil];
        return;
    }
    if (loginModel.JSID.length < 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginHaveTimeOut object:nil];
        return;
    }
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paraDic setValue:loginModel.JSID forKey:@"jsessionid"];
    [paraDic setValue:[IBXHelpers getStockLanguageType] forKey:@"CLV"];

    
    WEAKSELF
    [self qnTradePostPath:@"ServerTime" parameters:[self requestIbestJsonDicWithParams:paraDic] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code integerValue] == -2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginHaveTimeOut object:nil];
            return ;
        }
        if ([code integerValue] == 0 && [responseObject[@"result"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *RSDT = responseObject[@"result"][@"RSDT"];
            NSString *SRTM = [IBXHelpers getStringWithDictionary:RSDT andForKey:@"SRTM"];
//           SRTM = [SRTM substringToIndex:8];
            NSString *year = [SRTM substringToIndex:4];
            NSString *month = [SRTM substringWithRange:NSMakeRange(4, 2)];
            NSString *day = [SRTM substringWithRange:NSMakeRange(6, 2)];
            NSString *hour = [SRTM substringWithRange:NSMakeRange(8, 2)];
            NSString *minutes = [SRTM substringWithRange:NSMakeRange(10, 2)];
            NSString *seconds = [SRTM substringWithRange:NSMakeRange(12, 2)];
            NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year, month, day,hour, minutes, seconds];
            NSTimeInterval time = [IBXHelpers getTheNSTimeIntervalIS8WithDateString:dateStr];
            NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:time];
            
            [weakSelf.delegate ibGetSystemDateSuccessWithDate:nowDate withDateStr:dateStr];
        }else {
            [weakSelf.delegate ibGetSystemDateFailedWithInfor:[IBXHelpers getErrorInforWithString:responseObject[@"message"]] shouldPop:YES];
        }
        NSLog(@"%@_____获取系统时间成功", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.delegate ibGetSystemDateFailedWithInfor:KNetWork_Error shouldPop:NO];
    }];
    
}


@end

