//
//  IBUserHandler.m
//  iBestStandard
//
//  Created by bingo on 2018/5/25.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBUserHandler.h"

@implementation IBUserHandler

//session 自动登录
-(void)loginSessionWithDeviceInfo:(NSDictionary *) deviceInfo sessionId:(NSString *)sessionId                            resultBlock:(void (^) (id  responseObject, NSError *error))resultBlock
{
    NSMutableDictionary *params = [self defaultParamsDicWithSessionID];
    [ params setValue:deviceInfo forKey:@"deviceInfo"];
    params[@"sessionId"] = sessionId;
    NSString *path = @"user_session_login";
    NSDictionary *reqDic = [self requestJsonDicWithParams: params];
    WEAKSELF
    [self ibPostPath:path parameters:reqDic showErrorInView:nil needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(![responseObject isKindOfClass:[NSDictionary class]])
        {
            return ;
        }
        [weakSelf performBlockInMainThread:^{
            resultBlock(responseObject ,nil);
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf performBlockInMainThread:^{
            resultBlock(nil ,error);
        }];
    }];
}

@end
