
//
//  IBFXCustomHandleModel.m
//  iBestProduct
//
//  Created by xboker on 2018/1/5.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBFXCustomHandleModel.h"
//#import "IBFXHomeModel.h"
//#import "QNAppDelegate.h"
//#import "IBRootTabBarViewController.h"
//#import "IBFXSheetView.h"
//#import "IBSaveOptionalStockIdData.h"


@interface IBFXCustomHandleModel()
@end


@implementation IBFXCustomHandleModel
-(instancetype)init {
    self = [super initWithBaseURL: IB_FINANCIAL_SSL_BASE_URL];
    if (self) {
//        self.m_TradeHomeIndex = 1;
    }
    return self;
}


//获取系统配置信息 pm 的json文件 moduleName :mfinace ; key:sliver_gold_cfg;
-(void)ibFXGetSysCfgWithView:(UIView *)view
{
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paraDic setValue:@"mfinance" forKey:@"moduleName"];
    [paraDic setValue:@"sliver_gold_cfg" forKey:@"key"];
    [self ibFX_Trade_PostPath:@"getSysCfg" parameters:[self request_FX_JsonDicWithParams:paraDic] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {


        if ([responseObject isKindOfClass:[NSDictionary class]]) {

            NSDictionary * resultDic = responseObject[@"result"];

            NSDictionary * pmConfigDic = resultDic[@"data"];

            if(pmConfigDic != nil){
//                 [IBSaveOptionalStockIdData  saveOptionDictPlist:pmConfigDic plistName:PM_Config_Plist ];
            }


        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ///不做处理


    }];

}

/*
///外汇socket重连后 检测是否需要重新登录
- (void)ibFXCheckAccountNeedLoginWithView:(UIView *)view withController:(UIViewController *)controller withBlock:(void(^)(BOOL need))block {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (![IBGlobalMethod isFXTradeLogined]) {
        return;
    }
    [paraDic setValue:fxAccount().sessionID forKey:@"mfSessionId"];
    [paraDic setValue:fxAccount().loginAccount forKey:@"account"];
    [self qnFX_Trade_PostPath:@"checkUserOnline" parameters:[self request_FX_JsonDicWithParams:paraDic] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@______________获取是否需要重新登录的操作结果",responseObject);
        NSString *code = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"code"];
        if ([code isEqualToString:@"0"] || [code isEqualToString:@"8007"]) {
            NSDictionary *result = responseObject[@"result"];
            BOOL userOnline = [[IBXHelpers getStringWithDictionary:result andForKey:@"userOnline"] boolValue];
            if (userOnline) {
                ///不做处理
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (controller.xNavigationcontroller) {
                        if (App().rootTabbarVC.selectedIndex == 2 && ibFXHandler().m_TradeHomeIndex == 1) {
                            [controller.xNavigationcontroller popToRootViewControllerAnimated:YES];
                        }
                        [[[IBFXHomeModel alloc] init] fxLoginOutWithView:view withCallBack:nil];
                        [IBFXSheetView hideFXSheetView];
                    }
                });
                
            }
        }else {
            //不做处理
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ///不做处理
    }];
}

///贵金属socket重连后 检测是否需要重新登录
- (void)ibPMCheckAccountNeedLoginWithView:(UIView *)view withController:(UIViewController *)controller withBlock:(void(^)(BOOL need))block {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (![IBGlobalMethod isPMTradeLogined]) {
        return;
    }
    [paraDic setValue:pmAccount().sessionID forKey:@"mfSessionId"];
    [paraDic setValue:pmAccount().loginAccount forKey:@"account"];
    [self qnFX_Trade_PostPath:@"checkUserOnline" parameters:[self request_FX_JsonDicWithParams:paraDic] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@______________获取是否需要重新登录的操作结果",responseObject);
        NSString *code = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"code"];
        if ([code isEqualToString:@"0"] || [code isEqualToString:@"8007"]) {
            NSDictionary *result = responseObject[@"result"];
            BOOL userOnline = [[IBXHelpers getStringWithDictionary:result andForKey:@"userOnline"] boolValue];
            if (userOnline) {
                ///不做处理
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (controller.xNavigationcontroller) {
                        if (App().rootTabbarVC.selectedIndex == 2 && ibFXHandler().m_TradeHomeIndex == 2) {
                            [controller.xNavigationcontroller popToRootViewControllerAnimated:YES];
                        }
                        [[[IBFXHomeModel alloc] init] pmLoginOutWithView:view withCallBack:nil];
                        [IBFXSheetView hideFXSheetView];
                    }
                });
            }
        }else {
            //不做处理
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ///不做处理
    }];
}


///外汇订阅
- (void)fx_SubscribeActionWithView:(UIView *)view {

    if (fxAccount().sessionID == nil) {
        return;
    }
    //QNQuoteManager __weak *weakQuoteManager = QuoteManager();
    QNSocketSingleton __weak *weakSocket = Socket();
    if (weakSocket.channelId.length&&[weakSocket isConnected]) {
        [NetService().quoteHandler subscribeForexWithAssetIds:[IBFXQuoteConfig fxProductCodes] chnId:Socket().channelId funIds:@"24" subType:2 showErrorInView:view needShowError:NO ignoreCode:nil resultBlock:^(NSDictionary *responseDic, NSString *path, NSError *error) {
            if (!error) {
                NSLog(@"订阅成功！");

            }else{
                NSLog(@"订阅失败！");
            }
        }];
        [NetService().quoteHandler subscribeForexWithAssetIds:@[fxAccount().sessionID] chnId:Socket().channelId funIds:@"25,26,27,28,29,30,31,32,33" subType:2 showErrorInView:view needShowError:NO ignoreCode:nil resultBlock:^(NSDictionary *responseDic, NSString *path, NSError *error) {

            NSLog(@"%@_________外汇登录成功的订阅结果", responseDic);
            if (!error) {
                NSLog(@"订阅成功！");
            }else{
                NSLog(@"订阅失败！");
            }
        }];
    }
  

}

///贵金属订阅
- (void)pm_SubscribeActionWithView:(UIView *)view {
    if (pmAccount().sessionID == nil) {
        return;
    }
    //QNQuoteManager __weak *weakQuoteManager = QuoteManager();
    QNSocketSingleton __weak *weakSocket = Socket();
    if (weakSocket.channelId.length&&[weakSocket isConnected]) {
        [NetService().quoteHandler subscribeForexWithAssetIds:[IBFXQuoteConfig pmProductCodes] chnId:Socket().channelId funIds:@"24" subType:2 showErrorInView:view needShowError:NO ignoreCode:nil resultBlock:^(NSDictionary *responseDic, NSString *path, NSError *error) {
            if (!error) {
                NSLog(@"订阅成功！");
            }else{
                NSLog(@"订阅失败！");
            }
        }];
        [NetService().quoteHandler subscribeForexWithAssetIds:@[pmAccount().sessionID] chnId:Socket().channelId funIds:@"25,26,27,28,29,30,31,32,33" subType:2 showErrorInView:view needShowError:NO ignoreCode:nil resultBlock:^(NSDictionary *responseDic, NSString *path, NSError *error) {
            NSLog(@"%@_________贵金属登录成功的订阅结果", responseDic);
            if (!error) {
                NSLog(@"订阅成功！");
            }else{
                NSLog(@"订阅失败！");
            }
        }];
    }

}

///订阅所有
- (void)fx_pm_SubscribeAllWithView:(UIView *)view {
    [self fx_SubscribeActionWithView:view];
    [self pm_SubscribeActionWithView:view];
}

//
// 开仓, 改仓, 订单->持仓时, 调用接口重新获取所有的仓位
// 0: 外汇,   1: 贵金属
//
- (void)getAllCangWeiWithType:(NSInteger)type {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *requestID = [NSString stringWithFormat:@"REQUESTOPENPOSITIONS%ldIOS", (long)[[NSDate date] timeIntervalSince1970]];
    [paraDic setValue:requestID forKey:@"requestID"];
    if (type == 0) {
        [paraDic setValue:fxAccount().sessionID forKey:@"sessionID" ];
    }else {
        [paraDic setValue:pmAccount().sessionID forKey:@"sessionID" ];
    }
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
        sleep(1.5);
        [weakSelf qnFX_Trade_PostPath:@"requestOpenPositions" parameters:[weakSelf request_FX_JsonDicWithParams:paraDic] showErrorInView:nil needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            ///占位, 不处理
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            ///占位, 不处理
        }];
    });
}



//
// 外汇/贵金属显示出来安全须知弹窗, 点击确认下次是否继续显示
 
 //@param type MF:1 PM:2  MF_DEMO:3  PM_DEMO:4
 //
- (void)getNotShowSafeInstructionsAgainWithType:(NSInteger)type withView:(UIView *)view {
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *requestID = [NSString stringWithFormat:@"UPDATEISTIPS%ldIOS", (long)[[NSDate date] timeIntervalSince1970]];
    [paraDic setValue:requestID forKey:@"requestID"];
    [paraDic setValue:[@(type) stringValue] forKey:@"accountType"];

    [self qnFXPostPath:@"updateIsTips" parameters:[self request_FX_JsonDicWithParams:paraDic] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        ///占位不处理
        NSLog(@"%@______", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        ///占位不处理
        NSLog(@"%@______", error.userInfo);
    }];
    
}



///外汇/贵金属开户时需要的订阅
- (void)openAccountSubscribeWithView:(UIView *)view {
    [NetService().quoteHandler subscribeForexWithAssetIds:@[[IBGlobalMethod getAppLoginSession]] chnId:Socket().channelId funIds:@"35,38" subType:3 showErrorInView:view needShowError:NO ignoreCode:nil resultBlock:^(NSDictionary *responseDic, NSString *path, NSError *error) {
        NSLog(@"%@_________外汇贵金属开户时的订阅结果", responseDic);
        if (!error) {
            NSLog(@"订阅成功！");
        }else{
            NSLog(@"订阅失败！");
        }
    }];
}


- (void)getOpenAccountSubscribeWithB:(openAccountSubscribeB)subscribeB {
    if (subscribeB) {
        self.subscribeB = subscribeB;
    }
}


- (void)getOpenAccountSubscribeWithB2:(openAccountSubscribeB2)subscribeB2 {
    if (subscribeB2) {
        self.subscribeB2 = subscribeB2;
    }
}

*/




@end
