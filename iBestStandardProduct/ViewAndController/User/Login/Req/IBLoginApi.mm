//
//  IBLoginApi.m
//  IBApp
//  登录使用的请求
//  Created by tj on 11/12/15.
//  Copyright © 2015 Bacai. All rights reserved.
//

#import "IBLoginApi.h"
#import "IBBaseHttpClient.h"
#import "IBLoginParm.h"
#import "IBSecurityManager.h"
#import "CTDeviceInfo.h"

@interface IBLoginApi()

@property (nonatomic,strong) IBLoginParm * loginParm;

@end

@implementation IBLoginApi


#pragma mark – Public
- (id)initWithParm:(IBLoginParm *)loginParm {
    self =  [super initWithBaseURL:IB_SSL_USER_BASE_URL];
    if (self) {
        self.loginParm = loginParm;
    }
    return self;
}


//组装入参
-(NSDictionary *)requestArgument
{
    
    NSMutableDictionary *params = [self defaultParamsDicWithSessionID];
    params[@"certType"] = @(self.loginParm.certType);
    params[@"certCode"] = self.loginParm.certCode;
    params[@"areaType"] = @(self.loginParm.areaType);
    if ([self.loginParm.appID length])
    {
        params[@"appID"] = self.loginParm.appID;

    }
    if ([self.loginParm.pwd length])
    {
        //密码加密传输
        params[@"pwd"] = [sharedIBSecurityManager() encryptNetData:self.loginParm.pwd isPassword:true];
        params[@"key"] = [sharedIBSecurityManager() key];
    }
    if ([self.loginParm.token length])
    {
        params[@"token"] = self.loginParm.token;
    }
    params[@"deviceInfo"] = [CTDeviceInfo deviceDictionary];
    params[@"hasCheckNewDevice"] = @(self.loginParm.hasCheckNewDevice);  //添加一个入参
    params[TradeLoginAccount] = self.loginParm.tradeAccount;  //不一定要用
    NSDictionary *reqDic = [self requestJsonDicWithParams: params];
    
    return reqDic;
}


/**
 游客登录

 @param block block description
 */
-(void)ibGestLoginResultBlock:(void(^)(id response,NSError * error))block
{

    [self ibPostPath:@"user_login" parameters:[self requestArgument] showErrorInView:nil needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self performBlockInMainQueue:^{
            if (block) {
                block(nil,error);
            }
        }];
    }];
}



#pragma mark -Getter

- (NSString *)sessionId {
    return [self responseResultJSONObject][@"sessionId"];
}

- (NSDictionary*) userInfo {
    return [self responseResultJSONObject][@"userInfo"];
}
- (int32_t) userCode {
    return [[[self responseResultJSONObject] objectForKey:@"userCode"] intValue];
}
- (int64_t )userID {
    return [[[[self responseResultJSONObject] objectForKey:@"userId"] stringValue] longLongValue];
}

@end
