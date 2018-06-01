//
//  IBTradeCustomHandleModel.m
//  iBestProduct
//
//  Created by xboker on 2017/11/8.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBTradeCustomHandleModel.h"
#import "IBTradeLoginModle.h"
#import "QNSecurityManager.h"
#import "IBTradeSingleTon.h"



@implementation IBTradeCustomHandleModel
-(instancetype)init {
    self = [super initWithBaseURL: IB_SHARE_TRADE_BASE_URL];
    if (self) {
        self.canGoToForgetPswView = NO;
        self.canGoToForgetAccountView = NO;
    }
    return self;
}


/**
 获取是否可以进入忘记交易密码界面开关
 
 @param view 展示信息的view
 @param callBack 请求结束回调
 */
- (void)getForgetPSWViewStatusActionWithView:(UIView *)view withCallBack:(void(^)(void))callBack {
      NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:0];
    [para setValue:[IBXHelpers getStockLanguageType] forKey:@"CLV"];
    WEAKSELF
    [self qnTradePostPath:@"getFPSwitch" parameters:[self requestIbestJsonDicWithParams:para] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id code = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *result = responseObject[@"result"];
            NSString *FPSwitch = [IBXHelpers getStringWithDictionary:result andForKey:@"FPSwitch"];
            if ([FPSwitch boolValue] ) {
                weakSelf.canGoToForgetPswView = YES;
            }else {
                weakSelf.canGoToForgetPswView = NO;
            }
        }else {
            weakSelf.canGoToForgetPswView = NO;
        }
        if (callBack) {
            callBack();
        }
        NSLog(@"%@________获取是否可以进入忘记交易密码界面成功", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (callBack) {
            callBack();
        }
    }];
}


/**
 获取是否可以进入忘记交易账号界面开关
 
 @param view 展示信息的view
 @param callBack 请求结束回调
 */
- (void)getForgetAccountViewStatusActionWithView:(UIView *)view withCallBack:(void(^)(void))callBack {
    //    self.canGoToForgetAccountView = NO;
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:0];
    [para setValue:[IBXHelpers getStockLanguageType] forKey:@"CLV"];
    WEAKSELF
    [self qnTradePostPath:@"getFLSwitch" parameters:[self requestIbestJsonDicWithParams:para] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id code = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *result = responseObject[@"result"];
            NSString *FPSwitch = [IBXHelpers getStringWithDictionary:result andForKey:@"FLSwitch"];
            if ([FPSwitch boolValue] ) {
                weakSelf.canGoToForgetAccountView = YES;
            }else {
                weakSelf.canGoToForgetAccountView = NO;
            }
        }else {
            weakSelf.canGoToForgetAccountView = NO;
        }
        if (callBack) {
            callBack();
        }
        NSLog(@"%@________获取是否可以进入忘记交易登录名界面成功", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (callBack) {
            callBack();
        }
    }];
}




/**
 校验输入的交易密码
 
 @param psw 需要校验的交易密码
 @param success 校验成功
 @param failed 校验失败
 @param view 提示信息view
 */
- (void)verifyTradePasswordWithPsw:(NSString *)psw withSuccess:(void(^)(void))success withFailed:(void(^)(NSString *infor))failed withView:(UIView *)view {
    IBTradeLoginModle *loginModel = [[IBTradeLoginModle alloc] init];
    NSMutableDictionary *paraD = [NSMutableDictionary dictionaryWithCapacity:0];
    [paraD setValue:[IBXHelpers getStockLanguageType] forKey:@"CLV"];
    [paraD setValue:loginModel.JSID forKey:@"jsessionid"];
    [paraD setValue:[sharedQNSecurityManager() encryptNetData:psw isPassword:true]  forKey:@"password"];
    [paraD setValue:[sharedQNSecurityManager() key] forKey:@"key"];
    [self qnTradePostPath:@"VerifyPassword" parameters:[self requestIbestJsonDicWithParams:paraD] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary *RVPA = responseObject[@"result"][@"RVPA"];
            NSString *PAMA = [IBXHelpers getStringWithDictionary:RVPA andForKey:@"PAMA"];
            if ([PAMA isEqualToString:@"Y"]) {
                success();
            }else {
                failed(CustomLocalizedString(@"FX_BU_MIMACUOWUQINGCHONGXINSHURU", nil));
            }
        }else {
            failed([IBXHelpers getErrorInforWithString:responseObject[@"message"]]);
        }
        NSLog(@"%@-----校验交易密码回调", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failed(KNetWork_Error);
    }];
}


/**
 交易登录后点击保存密码后的回调
 
 @param view 显示信息view
 @param keepResult 保存结果回调
 */
- (void)tradeLoginKeepPSWWithView:(UIView *)view withResult:(void(^)(BOOL keepSuccess, NSString *infor))keepResult{
    NSMutableDictionary *paraD = [NSMutableDictionary dictionaryWithCapacity:0];
    [paraD setValue:[IBXHelpers getStockLanguageType] forKey:@"CLV"];
    NSString *jsID = [IBXHelpers getStringWithDictionary:[IBTradeSingleTon shareTradeSingleTon].m_LoginUserDic andForKey:@"JSID"];
    if (jsID.length < 5) {
        return;
    }
    [paraD setValue:jsID forKey:@"jsessionid"];
    [self qnTradePostPath:@"keepPassword" parameters:[self requestIbestJsonDicWithParams:paraD] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@___________交易登录点击保存密码的结果回调", responseObject);
        NSString *code = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"code"];
        if ([code isEqualToString:@"0"]) {
            NSDictionary * RKPA = responseObject[@"result"][@"RKPA"];
            NSString *KPAS = [IBXHelpers getStringWithDictionary:RKPA andForKey:@"KPAS"];
            if ([KPAS.uppercaseString isEqualToString:@"SUCCESS"]) {
                sleep(0.5);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginSuccess object:nil];
                });
                keepResult(YES, nil);
            }else {
                keepResult(NO, CustomLocalizedString(@"FX_BU_BAOLIUMIMASHIBAIQINGCHOGNSHI", nil));
            }
        }else {
            keepResult(NO, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        keepResult(NO, KNetWork_Error);
    }]; 
}




@end

