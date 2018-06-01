//
//  QNSocketSingleton.m
//  QNEngine
//
//  Created by weiheng on 15/7/28.
//  Copyright (c) 2015年 Bacai. All rights reserved.
//


//#import "GCDAsyncSocket.h"
#import "IBSocket.h"
//#import "QNService.h"
#import <GCDAsyncSocket.h>
//#import "IBFXQuoteOpr.h"

#define dataHeadLenght  10 //包头的长度

@interface IBSocket()<GCDAsyncSocketDelegate>{
    
    NSInteger fileLength; //数据长度
    NSInteger currentFunction;//当前的功能号
    NSString * old_channelId;
    BOOL cutOffSocketByUser;
}

@property (nonatomic, strong) GCDAsyncSocket *socket;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *checkSocketTimer;
@property (nonatomic, strong) NSMutableData *socketData;
@property (nonatomic) BOOL bSocketStates; //NO  没连上；yes 连上了。
@property (nonatomic) NSInteger soketReadDataCount;
@property (nonatomic) NSInteger soketConnectedCheckCount;
@property (nonatomic) NSInteger reconnectCount;//重连接次数

@end

@implementation IBSocket

- (id)init{
    
    self = [super init];
    
    if (self) {
        self.bSocketStates = NO;
        [self creatCheckSocketTimer];
        
        
        
        
        /*  //通知相关要处理的 后续
         [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(handleNetWorkChangeNotify)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        */

    }
    return self;
}



#pragma mark - 前后台考虑
/*-(void)didBecomeActive
{
    [self creatCheckSocketTimer];
//    [self createTimer];
    if([self.socket isDisconnected])
    {
        [self cutOffSocket];
        WEAKSELF
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf socketConnectHost];
        });
    }
}

-(void)didBecomeResignActive
{
//    [self checkSocketTimerInvalid];
}*/

#pragma mark - 通知处理

/*- (void)handleNetWorkChangeNotify{
    
    if([self.socket isDisconnected])
    {
        [self cutOffSocket];
        WEAKSELF
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf socketConnectHost];
        });
    }
}
*/


#pragma mark  -  GCDAsyncSocketDelegate 连接成功回调

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
   NSLog(@"socket连接成功");

    self.needReconnect = NO;
    self.bSocketStates = YES;
    self.soketConnectedCheckCount = 0;
    self.soketReadDataCount = 0 ;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSocket_Reconnect  object:nil];
    //握手
    [self shakeHandsWithServer];
    
    [sock readDataToLength:dataHeadLenght withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
//   NSLog(@"socket  Write完成--------------------------");

}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"sorry the connect is failure %@",err);

    self.soketConnectedCheckCount = 4;
    self.soketReadDataCount = 0 ;
    self.bSocketStates = NO;
    if ([self.socket isConnected]) {
        self.needReconnect = NO;
        return;
    }else{
        self.needReconnect = YES;
    }

    [self.timer invalidate];
    _timer = nil;

    [self.socket readDataWithTimeout:-1 tag:0];
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
   /* if (tag==0) {
        //读取的是包头数据
        if (data.length==dataHeadLenght) {
            
            Byte *byte = (Byte *)[data bytes];
            fileLength = (((byte[4] & 0xff) << 8*3) | ((byte[5] & 0xff) << 8*2) |((byte[6] & 0xff) << 8) |(byte[7] & 0xff));
            short fNum = (short) (((byte[1] & 0xff) << 8) | (byte[2] & 0xff));
            currentFunction = fNum;
            self.socketData = nil;
            
            self.soketReadDataCount = 0;
            if (fNum == Function_Heartbeat) {
                NSLog(@"--------收到心跳------");

 
            }else if (fNum==Function_Clear_Data) {
                NSLog(@"收到清盘通知!~~~~");
                if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastCleanDate"]) {
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:-23*60*60] forKey:@"lastCleanDate"];
                }
                
                NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastCleanDate"];
                NSDate *date = [NSDate date];
                NSTimeInterval interval = [date timeIntervalSinceDate:lastDate];
                if (interval>=23*60*60) {
                    //清盘  确保每天只清盘一次
                    [[NSNotificationCenter defaultCenter] postNotificationName:kQuotes_Clear_Data  object:nil];
                    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"lastCleanDate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    
                }
            }
            
            if (fileLength) {
                [sock readDataToLength:fileLength withTimeout:-1 tag:1];
            }else {
                [sock readDataToLength:dataHeadLenght withTimeout:-1 tag:0];
            }
        }
    }
    else if (tag==1){
        //取到包体的数据
        if (!_socketData) {
            self.socketData = [NSMutableData dataWithCapacity:0];
        }
        [_socketData appendData:data];
        
        if (data.length<fileLength) {
            //仍未读取完数据
            fileLength-=data.length;
            //继续读取包体
            [sock readDataToLength:fileLength withTimeout:-1 tag:1];
        }
        else{
            //读取完数据
            NSString *jsonString = [[NSString alloc] initWithData:_socketData encoding:NSUTF8StringEncoding];
//           NSLog(@"socket获取到数据---%@",jsonString);
            NSLog(@"***********socket read data*************");
            id object = [NSJSONSerialization JSONObjectWithData:_socketData options:NSJSONReadingMutableContainers error:nil];
            
            if (object) {
                
                if (currentFunction==Function_Login) {
                    //登录结果
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *infoDic = object;
                        old_channelId = self.channelId;
                        if (infoDic[@"channelId"]) {
                            NSString * channelId = infoDic[@"channelId"];
                            if (channelId.length>0 && [channelId isEqualToString:INVALID_SESSION]== NO) {
                                 self.channelId = channelId;
                            }
                        }

                        [[NSNotificationCenter defaultCenter] postNotificationName:kSocket_Reconnect  object:nil];

                        //链接上了 将重连次数设置为0
                        self.reconnectCount = 0;
                        self.needReconnect = NO;

                    }
                }
                else if (currentFunction==Function_Real_time_Quotes){
                    //实时行情
                    NSLog(@"*******推送实时行情**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReal_Time_Quotes  object:object];
                }
                else if (currentFunction==Function_Funds_Real_time_Quotes){
                    //基金实时行情
                     NSLog(@"*******推送基金实时行情**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kFunds_Real_time_Quotes  object:object];
                }
                else if (currentFunction==Function_Index_Real_time_Quotes){
                    //指数实时行情
                     NSLog(@"*******推送指数实时行情**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIndex_Real_time_Quotes  object:object];
                    
                }
                else if (currentFunction==Function_Five_Leve_Sale){
                    //买卖五档
                     NSLog(@"*******推买卖五档**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kFive_Leve_Sale  object:object];
                }
                else if (currentFunction==Function_Time_Share){
                    //分时
                     NSLog(@"*******推送分时**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kTime_Share  object:object];
                }
                else if (currentFunction==Function_Share_Transaction_Details){
                    //个股成交明细
                }else if (currentFunction == Function_Optional_Stock) {
                    //自选股行情
                     NSLog(@"*******推送自选股行情**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kOptional_Stock_Real_Time_Quotes object:object];
                }else if (currentFunction == Function_Tape) {
                    //大盘指数行情
                     NSLog(@"*******推送大盘指数行情**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kTape_Real_Time_Quotes object:object];
                }else if (currentFunction == Function_Concept) {
                    //概念数据
                     NSLog(@"*******推送概念数据**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kConcept_Real_Time_Quotes object:object];
                }else if (currentFunction == Function_Industry) {
                    //行业数据
                     NSLog(@"*******推送行业数据**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kIndustry_Real_Time_Quotes object:object];
                }else if (currentFunction == Function_Hot_Stock) {
                    //热门个股行情
                     NSLog(@"*******推送热门个股行情**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kHot_Stock_Real_Time_Quotes object:object];
                }else if (currentFunction == Function_Market_Index) {
                    //市场首页合并推送
                     NSLog(@"*******推送市场首页合并推送**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kMarket_Index_Quotes object:object];
                }else if (currentFunction == Function_Optional_Portfolio) {
                    //自选组合推送
                     NSLog(@"*******推送自选组合推送**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:kOptional_Portfolio object:object];
                }else if (currentFunction == Function_Market_HKStocksPrice){
                    //港股十档行情通道
                    NSLog(@"*******推送港股十档行情通道**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:KMarket_HKStocksPrice object:object];

                }else if(currentFunction == Function_Market_HKStocksBroker){
                    //港股经纪行情通道
                      NSLog(@"*******推送港股经纪行情通道**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:KMarket_HKStocksBroker object:object];
                }else if(currentFunction == Function_Per_Deal)
                {
                    //逐笔成交
                    NSLog(@"*******推送 HK 逐笔成交通道**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:KMarket_Per_Deal object:object];
                }else if(currentFunction == Function_Per_Deal_SH){
                    NSLog(@"*******推送 SH 逐笔成交通道**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:KMarket_Per_Deal_SH object:object];
                }else if(currentFunction == Function_Per_Deal_SZ){
                    NSLog(@"*******推送 SZ 逐笔成交通道**********");
                    [[NSNotificationCenter defaultCenter] postNotificationName:KMarket_Per_Deal_SZ object:object];
                }else if(currentFunction == Function_Foreign_Exchange){
//                    NSLog(@"********来外汇数据了***************");
                    //处理行情数据
                    [IBFXQuoteManager updateFXQuoteData:object];

                }else if (currentFunction == Function_FX_Account_Infor) {
                    ///更新外汇账户信息
                    NSLog(@"********更新外汇账户信息***************");
                    NSString *SessionID = [IBXHelpers getStringWithDictionary:object andForKey:@"SessionID"];
                    ///外汇
                    if ([IBGlobalMethod isFXTradeLogined] && [fxAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [fxTDManager() updateAccountInforWithData:object];
                        });
                    }
                    ///贵金属
                    if ([IBGlobalMethod isPMTradeLogined] && [pmAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [pmTDManager() updateAccountInforWithData:object];
                        });
                    }

                }else if (currentFunction == Function_FX_Order_Modify_History) {
                    ///下单、改单历史记录的推送频道名
                    NSLog(@"********下单、改单历史记录的推送频道名***************");
                    NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                    ///外汇
                    if ([IBGlobalMethod isFXTradeLogined] && [fxAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [fxTDManager() handleWeiTuoHistoryWithData:object[@"Data"][@"Info"] isCancleOrder:NO];
                        });
                    }
                    ///贵金属
                    if ([IBGlobalMethod isPMTradeLogined] && [pmAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [pmTDManager() handleWeiTuoHistoryWithData:object[@"Data"][@"Info"] isCancleOrder:NO];
                        });
                    }
                }else if (currentFunction == Function_FX_Resign_Order_History) {
                    ///撤单历史
                    NSLog(@"********撤单历史***************%@", object);
                    NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                    ///外汇
                    if ([IBGlobalMethod isFXTradeLogined] && [fxAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [fxTDManager() handleWeiTuoHistoryWithData:object[@"Data"][@"Info"] isCancleOrder:YES];
                        });
                    }
                    ///贵金属
                    if ([IBGlobalMethod isPMTradeLogined] && [pmAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [pmTDManager() handleWeiTuoHistoryWithData:object[@"Data"][@"Info"] isCancleOrder:YES];
                        });
                    }
                }else if (currentFunction == Function_FX_Ping_Cang) {
                    ///平仓历史
                    NSLog(@"********平仓历史***************%@", object);
                    NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                    ///外汇
                    if ([IBGlobalMethod isFXTradeLogined] && [fxAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [fxTDManager() handelPingCangHistoryWithData:object[@"Data"][@"Info"]];
                        });
                    }
                    ///贵金属
                    if ([IBGlobalMethod isPMTradeLogined] && [pmAccount().sessionID isEqualToString:SessionID]) {
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [pmTDManager() handelPingCangHistoryWithData:object[@"Data"][@"Info"]];
                        });
                    }
                }else if (currentFunction == Function_FX_DingDan_BianDong) {
                    ///订单变动__委托单
                    NSLog(@"********订单变动***************%@", object);
                    NSString *SessionID = [IBXHelpers getStringWithDictionary:object andForKey:@"SessionID"];
                    ///外汇
                    if ([IBGlobalMethod isFXTradeLogined] && [fxAccount().sessionID isEqualToString:SessionID]) {
                        if (fxTDManager().m_WeiTuoArr.count) {
                            return;
                        }
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [fxTDManager() fetchWeiTuoArrWithData:object[@"Data"] isAdd:YES];
                        });
                    }
                    ///贵金属
                    if ([IBGlobalMethod isPMTradeLogined] && [pmAccount().sessionID isEqualToString:SessionID]) {
                        if (pmTDManager().m_WeiTuoArr.count) {
                            return;
                        }
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [pmTDManager() fetchWeiTuoArrWithData:object[@"Data"] isAdd:YES];
                        });
                    }

                    
                }else if (currentFunction == Function_FX_CangWei_BianDong) {
                    NSLog(@"********仓位变动***************%@", object);
                    NSString *SessionID = [IBXHelpers getStringWithDictionary:object andForKey:@"SessionID"];
                    ///外汇
                    if ([IBGlobalMethod isFXTradeLogined] && [fxAccount().sessionID isEqualToString:SessionID]) {
                        ///仓位变动
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [fxTDManager() fetchCangWeiArrWithData:object[@"Data"] addNew:NO];
                        });
                    }
                    ///贵金属
                    if ([IBGlobalMethod isPMTradeLogined] && [pmAccount().sessionID isEqualToString:SessionID]) {
                        ///仓位变动
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [pmTDManager() fetchCangWeiArrWithData:object[@"Data"] addNew:NO];
                        });
                    }
            }else if (currentFunction == Function_FX_Account_Setting) {
                    NSLog(@"********账户设置***************");
                    NSString *SessionID = [IBXHelpers getStringWithDictionary:object andForKey:@"SessionID"];
                    ///外汇
                    if ([IBGlobalMethod isFXTradeLogined] && [fxAccount().sessionID isEqualToString:SessionID]) {
                        ///账户设置
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            [fxTDManager() updateAccountSettingWithData:object];
                        });
                    }
                    ///贵金属
                if ([IBGlobalMethod isPMTradeLogined] && [pmAccount().sessionID isEqualToString:SessionID]) {
                    ///账户设置
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [pmTDManager() updateAccountSettingWithData:object];
                    });
                }

                }else if (currentFunction == Function_FX_Action_GengXin) {
                    ///action更新
                    NSLog(@"********action更新***************%@", object);
                    NSInteger  Action = [[IBXHelpers getStringWithDictionary:object andForKey:@"Action"] integerValue];
                    switch (Action) {///relogin
                        case 11: {
                            NSDictionary *Data = object[@"Data"];
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:Data andForKey:@"SessionID"];
                            if (SessionID.length) {
                                ///外汇
                                if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[NSNotificationCenter defaultCenter] postNotificationName:FX_PM_Infor_ReLogin object:@"0"];
                                    });
                                }
                                //贵金属
                                if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[NSNotificationCenter defaultCenter] postNotificationName:FX_PM_Infor_ReLogin object:@"1"];
                                    });
                                }
                            }
                            break;
                        }
                        case 23: {///Order  To   Position
                            NSLog(@"%@___________-订单变为仓位, 这个订单的信息", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                NSDictionary *Data = object[@"Data"];
                                BOOL success = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (success) {
                                    NSDictionary *Info = Data[@"Info"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() handel_OrderToPosition_WithData:Info];
//                                        [ibFXHandler() getAllCangWeiWithType:0];
                                    });
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                NSDictionary *Data = object[@"Data"];
                                BOOL success = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (success) {
                                    NSDictionary *Info = Data[@"Info"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() handel_OrderToPosition_WithData:Info];
//                                        [ibFXHandler() getAllCangWeiWithType:1];
                                    });
                                }
                            }
                            
                            
                            break;
                        }
                        case 24: {///Order  To   Position   The Position Deatail
                            NSLog(@"%@___________-订单变为仓位, 这个仓位的详细信息", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                NSDictionary *Data = object[@"Data"];
                                BOOL success = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                id Info = Data[@"Info"];
                                if (success) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        if ([Info isKindOfClass:[NSArray class]]) {
                                            [fxTDManager() handel_AddPostion_WithData:Info];
//                                            [ibFXHandler() getAllCangWeiWithType:0];
                                        }
                                        if ([Info isKindOfClass:[NSDictionary class]]) {
                                            [fxTDManager() handel_AddPostion_WithData:@[Info]];
//                                            [ibFXHandler() getAllCangWeiWithType:1];
                                        }
                                    });
                                }
                            }
                            //贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                NSDictionary *Data = object[@"Data"];
                                BOOL success = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                id Info = Data[@"Info"];
                                if (success) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        if ([Info isKindOfClass:[NSArray class]]) {
                                            [pmTDManager() handel_AddPostion_WithData:Info];
                                        }
                                        if ([Info isKindOfClass:[NSDictionary class]]) {
                                            [pmTDManager() handel_AddPostion_WithData:@[Info]];
                                        }
                                    });
                                }
                            }
                        break;
                        }
                        case 31: {///newOrder
                            NSLog(@"%@_________下新单回调结果", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() fetchWeiTuoArrWithData:@[Info] isAdd:YES];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() fetchWeiTuoArrWithData:@[Info] isAdd:YES];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            
                            break;
                        }
                        case 32: {///modifyOrder
                            NSLog(@"%@_________改单回调结果", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() modifyWeiTuoWithData:@[Info] ];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() modifyWeiTuoWithData:@[Info] ];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            
                            break;
                        }
                        case 33:{///resignOrder
                            NSLog(@"%@_________撤单回调结果", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() fetchWeiTuoArrWithData:@[Info] isAdd:NO];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() fetchWeiTuoArrWithData:@[Info] isAdd:NO];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            break;
                        }
                        case 41: {///newPosition
                            NSLog(@"%@_________下新的仓位回调结果", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    ///处理数据
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"PositionID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() fetchCangWeiArrWithData:@[Info] addNew:YES];
//                                        [ibFXHandler() getAllCangWeiWithType:0];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    ///处理数据
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"PositionID"];
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() fetchCangWeiArrWithData:@[Info] addNew:YES];
//                                        [ibFXHandler() getAllCangWeiWithType:1];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            break;
                        }
                        case 42: {///positionModify
                            NSLog(@"%@_________修改仓位回调结果", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"PositionID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                        [ibFXHandler() getAllCangWeiWithType:0];
                                        [fxTDManager() modifyCangWeiWithData:@[Info]];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"PositionID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() modifyCangWeiWithData:@[Info]];
//                                        [ibFXHandler() getAllCangWeiWithType:1];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            break;
                        }
                        case 43: {///closeAllPosition
                            NSLog(@"%@_________全部平仓回调结果", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() pingCangWei_AllWithData:@[Info]];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() pingCangWei_AllWithData:@[Info]];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            break;
                        }
                        case 44: {//sigleClosePositon
                            NSLog(@"%@_________单一平仓回调结果", object);
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"ClosePositionID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() pingCangWei_SingleWithData:@[Info]];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"ClosePositionID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() pingCangWei_SingleWithData:@[Info]];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            break;
                        }
                        case 45: {///triggerClosePosition
                            NSString *SessionID = [IBXHelpers getStringWithDictionary:object[@"Data"] andForKey:@"SessionID"];
                            ///外汇
                            if ([SessionID isEqualToString:fxAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [fxTDManager() pingCangWei_SingleWithData:@[Info]];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            ///贵金属
                            if ([SessionID isEqualToString:pmAccount().sessionID]) {
                                IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                                IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                                NSDictionary *Data = object[@"Data"];
                                BOOL BSuccess = [[IBXHelpers getStringWithDictionary:Data andForKey:@"BSuccess"] boolValue];
                                if (BSuccess) {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = YES;
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = nil;
                                    NSDictionary *Info = object[@"Data"][@"Info"];
                                    IBFXData().fxTCPStatus.position_order_ID = [IBXHelpers getStringWithDictionary:Info andForKey:@"OrderID"];
                                    ///处理数据
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        [pmTDManager() pingCangWei_SingleWithData:@[Info]];
                                    });
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(YES);
                                    }
                                }else {
                                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                                    NSDictionary *MfErr = Data[@"MfErr"];
                                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:MfErr andForKey:@"StrErrMsg"];
                                    if (IBFXData().fxTCPStatus.resultCallBack) {
                                        IBFXData().fxTCPStatus.resultCallBack(NO);
                                    }
                                }
                            }
                            break;
                        }
                        default:
                            break;
                    }
                    
                }else if (currentFunction == Function_FX_Toast_GengXin) {
                    ///toast更新
                    NSLog(@"********toast更新***************%@", object);
                    NSDictionary *Data = object[@"Data"];
                    IBFXData().fxTCPStatus.TCP_Data_Get = YES;
                    IBFXData().fxTCPStatus.TCP_TimeOut = NO;
                    IBFXData().fxTCPStatus.TCP_OrderSuccess = NO;
                    IBFXData().fxTCPStatus.TCP_FailedInfor = [IBXHelpers getStringWithDictionary:Data andForKey:@"ErrMsg"];
                    if (IBFXData().fxTCPStatus.specialResultCallBack) {
                        IBFXData().fxTCPStatus.specialResultCallBack(NO);
                    }
                }else if (currentFunction == Function_FX_PMOpenAccountGetData_35) {
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        if (ibFXHandler().subscribeB) {
                            ibFXHandler().subscribeB((NSDictionary *)object);
                        }
                    }
                }else if (currentFunction == Function_FX_PMOpenAccountGetData_38) {
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        if (ibFXHandler().subscribeB2) {
                            ibFXHandler().subscribeB2((NSDictionary *)object);
                        } 
                    }
                }
                self.socketData = nil;
                //继续读取包头
                [sock readDataToLength:dataHeadLenght withTimeout:-1 tag:0];
            }
            else{
                //无法解析数据错误
                self.socketData = nil;
                [self cutOffSocket];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self socketConnectHost];
                });

            }
        }
    }
    */
}




#pragma mark - Private

//链接主机
-(void)socketConnectHost
{
    
    if (!_socket)
    {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.socket.IPv4PreferredOverIPv6 = NO;
    }
    _socketData = nil;
    NSError *error = nil;
    if (![self.socket isConnected])
    {
        [self.socket connectToHost:IB_SOCKET_HOST onPort:IB_SOCKET_PORT withTimeout:10 error:&error];
    }
    NSLog(@" socket connect host Err  %@",error);
}
// 包头
- (NSMutableData *)pagekageHeaderWithAppLogo:(int)logoLot functionNum:(int)fNum versionNum:(int)vNum dataLenght:(int)dLenght{
    //app标志位
    Byte byte[] = {logoLot};
    NSMutableData *dataToSend = [NSMutableData dataWithBytes:byte length:1];
    //功能号
    Byte b[2];
    b[0] = (Byte) (fNum >> 8);
    b[1] = (Byte) (fNum);
    NSData *adata = [[NSData alloc] initWithBytes:b length:2];
    [dataToSend appendData:adata];
    
    //版本号
    Byte byte2[] = {vNum};
    adata = [[NSData alloc] initWithBytes:byte2 length:1];
    [dataToSend appendData:adata];
    
    //创建前4个字节用来表示数据包长度
    uint8_t len[4];
    
    for(int i = 0;i<4;i++)
    {
        len[i] = (Byte)(dLenght>>8*(3-i)&0xff);
    }
    
    //将这4个字节添加到数据的开头
    
    adata = [[NSData alloc] initWithBytes:len length:4];
    [dataToSend appendData:adata];
    
    //后面两个byte
    Byte byte3[] = {0};
    adata = [[NSData alloc] initWithBytes:byte3 length:1];
    [dataToSend appendData:adata];
    [dataToSend appendData:adata];
    
    return dataToSend;
    
}


// 握手
- (void)shakeHandsWithServer{

   //如果channelId存在 就传channelId给服务器
  /*  NSMutableDictionary * mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"HelloServer" forKey:@"token"];
    
    if ([IBGlobalMethod getAppLoginSession].length>0 && [[IBGlobalMethod getAppLoginSession] isEqualToString:INVALID_SESSION]==NO) {
        [mDict setObject:[IBGlobalMethod getAppLoginSession] forKey:@"channelId"];
    }
    NSError * error ;
    NSData *data = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:&error]; //NSJSONReadingAllowFragments

    if (error) {
        NSLog(@"%@",error);
    }



    NSInteger dataLength = data.length;
    NSMutableData *dataToSend = [self pagekageHeaderWithAppLogo:0 functionNum:Function_Login versionNum:1 dataLenght:(int)dataLength];
    [dataToSend appendData:data];
    
    [self.socket writeData:dataToSend withTimeout:-1 tag:1];
    //发送开始心跳
    [self createTimer];
   */
}

#pragma mark - 心跳连接

- (void)createTimer{
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }else{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
        [self.timer fire];
    }
    
}

-(void)longConnectToSocket{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableData *dataToSend = [self pagekageHeaderWithAppLogo:0 functionNum:Function_Heartbeat versionNum:1 dataLenght:0];
        [self.socket writeData:dataToSend withTimeout:-1 tag:1];
    });

    
}

-(void)cutOffSocket{
    NSLog(@"主动关闭socket断开");
    [self.timer invalidate];
    _timer = nil;
    if(![self.socket isDisconnected])
    {
        [self.socket disconnect];
        
    }
    _reconnectCount = 0;
    self.socketData = nil;
    [self.socket disconnect];
    
    [_socket setDelegate:nil];
    _socket=nil;
}

- (BOOL)isConnected{
    
    return _socket.isConnected;
}

#pragma mark - 定时监控 socket 状态
- (void)creatCheckSocketTimer{
    [self.checkSocketTimer invalidate];
    self.checkSocketTimer = nil;
    [self.checkSocketTimer fire];
}

- (NSTimer *)checkSocketTimer {
    if (!_checkSocketTimer) {
        _checkSocketTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(checkSocketStates) userInfo:nil repeats:YES];
    }
    return _checkSocketTimer;
}

-(void)checkSocketTimerInvalid
{
    [self.checkSocketTimer  invalidate];
    self.checkSocketTimer = nil;
}

-(void)checkSocketStates
{
//    NSLog(@"&&&&&&&&  开始检测socket  &&&&&&&&&&");
    if (self.bSocketStates == NO) { //3s
//        NSLog(@"-------连接……");
        self.soketConnectedCheckCount++;
        if(self.soketConnectedCheckCount>=4){
       
            [self cutOffSocket];

            WEAKSELF
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                 [weakSelf socketConnectHost];
                 weakSelf.soketConnectedCheckCount = 0;
            });
        }
    }else{
        //15s
        self.soketReadDataCount++;
        if (self.soketReadDataCount>=8) {
            NSLog(@"执行了24s超时");
      
            [self cutOffSocket];
            WEAKSELF
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakSelf socketConnectHost];
                weakSelf.soketReadDataCount = 0;
            });
        }
    }
}

@end
