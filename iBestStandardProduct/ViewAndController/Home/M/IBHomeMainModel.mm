//
//  IBHomeMainModel.m
//  QNApp
//
//  Created by xboker on 2017/4/21.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "IBHomeMainModel.h"

#import "IBGlobalMethod.h"
#import "IBSaveOptionalStockIdData.h"
#import "IBOptionPlistSingleton.h"
//#import "IBXHelpers.h"
#import "IBXCache.h"

#import "QNService.h"
#import "QNUserSystemManager.h"

#import "IBTradeSingleTon.h"
#import "QNAppDelegate.h"
#import "IBRootTabBarViewController.h"


#define KAssertIds  @[@"00665.HK",@"06837.HK",@"HSI.IDX.HK"] //海通证券 海通国际 恒生指数，


@interface IBHomeMainModel()


#pragma mark    以下预废弃
@property (nonatomic, assign) NSInteger m_PropertyPageNum;
@property (nonatomic, assign) NSInteger m_PropertyFlag;

@property (nonatomic, assign) NSInteger m_MarketPageNum;
@property (nonatomic, assign) NSInteger m_MarketFlag;

@property (nonatomic, assign) NSInteger m_StockLevelNum;
@property (nonatomic, assign) NSInteger m_StockLevleFlag;
#pragma mark    以上预废弃


@property (nonatomic, assign) NSUInteger m_InformationPage;
@property (nonatomic, assign) NSUInteger m_InformationFlag;



@property (nonatomic, strong) NSMutableArray *CacheShiChangDongTaiArr;
@property (nonatomic, strong) NSMutableArray *CacheCaiFuZiXunArr;
@property (nonatomic, strong) NSMutableArray *CacheReMenZiXUnArr;
@property (nonatomic, strong) NSMutableArray *CacheTurnImageArr;
//@property (nonatomic, strong) NSMutableArray *CacheChooseStocksArr;
@property (nonatomic, strong) NSMutableArray *CacheStockLevelArr;




//@property (nonatomic, strong) NSMutableDictionary *m_ParaDic;

@end


@implementation IBHomeMainModel



-(instancetype)init {
    self = [super initWithBaseURL: QN_SSL_QUOTE_BASE_URL];
    if (self) {
//        self.m_PropertyPageNum = 1;
//        self.m_PropertyFlag = 9999;
//        self.m_MarketPageNum = 1;
//        self.m_MarketFlag = 999;
//        self.m_StockLevelNum = 1;
//        self.m_StockLevleFlag = 999;
        self.m_InformationPage = 1;
        self.m_InformationFlag = MAXFLOAT;
        
        self.m_UnreadMessageCount = 0;
    }
    return self;
}



#pragma mark    获取首页轮播轮播图
- (void)getTurnImageActionWithView:(UIView *)view {

    WEAKSELF
    if ([IBXHelpers getNetWorkStatus] == 0) {
        [weakSelf.delegate ibHomeCustomGetHomeTurnImageSuccessWithInFor:@""];
        return;
    }
    NSMutableDictionary *dic = [IBXHelpers getSignIBestRequestWithSession];
    [dic setObject:@"home" forKey:@"position"];

    if ([IBGlobalMethod isLogin]) {
        if ([IBGlobalMethod getTradeAccountId].length > 2) {
            [dic setValue:@"9" forKey:@"type"];
        }else {
            [dic setValue:@"1" forKey:@"type"];
        }
    }else {
        [dic setValue:@"0" forKey:@"type"];
    }
    [self qnPostPath:@"get_appbanner" parameters:[self requestJsonDicWithParams:dic] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id data = responseObject[@"data"];
        if ([data isKindOfClass:[NSArray class]]) {
            [weakSelf.m_TurnImageArr removeAllObjects];
            [weakSelf.m_TurnImageArr addObjectsFromArray:data];
            if (weakSelf.m_TurnImageArr.count == 0) {
                [weakSelf.m_TurnImageArr addObject:[UIImage imageNamed:@"home02"]];
            }
        }
        [weakSelf.delegate ibHomeCustomGetHomeTurnImageSuccessWithInFor:@""];
        NSLog(@"%@_______________获取轮播图成功", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.m_TurnImageArr removeAllObjects];
        [weakSelf.m_TurnImageArr addObject:[UIImage imageNamed:@"home01"]];
        [weakSelf.m_TurnImageArr addObject:[UIImage imageNamed:@"home02"]];
        [weakSelf.m_TurnImageArr addObject:[UIImage imageNamed:@"home03"]];
        [weakSelf.delegate ibHomeCustomGetHomeTurnImageSuccessWithInFor:@""];
    }];
}






#pragma mark    获取自选股assertID
- (void)getSelfChooseStockAction {
    if ([IBGlobalMethod isGestType]==YES) {  //游客从本地拿plist
        [self loadPlistDataWithName:G_GestPlistName];
        [self.delegate ibHomeCustomGetSelfChooseStockSuccessStatus:YES];
        return;
    }else{
        [self requestOptionalStock];
    }
}


#pragma mark - 从plist中读数据
//是游客的话，从本地plist文件中取  后须处理
-(void)loadPlistDataWithName:(NSString *)plistname {
    NSDictionary * plistDict = [IBSaveOptionalStockIdData getPlistDataWithName:plistname];
    if(plistDict == nil){
        //停止刷新
        [self.delegate ibHomeCustomGetSelfChooseStockSuccessStatus:NO];
        return;
    }
    NSArray * assetsArr = plistDict[@"assetIds"];
    if (assetsArr.count > 0)  {
        [IBOptionPlistSingleton shareIntance].plistDict = [NSMutableDictionary dictionaryWithDictionary:plistDict];
        [[IBOptionPlistSingleton shareIntance].groupNamesArrsy removeAllObjects];
        [[IBOptionPlistSingleton shareIntance].datasArray removeAllObjects];
        for (int i=0;i<assetsArr.count ;i++) {
            NSDictionary * dict = assetsArr[i];
            NSString * name = dict[@"name"];
            NSArray * array = [NSArray array];
            if (dict[@"data"]) {
                array = dict[@"data"];
            }else{
                array =[NSArray array];
            }
            [[IBOptionPlistSingleton shareIntance].groupNamesArrsy addObject:name]; //所有的组名
            [[IBOptionPlistSingleton shareIntance].datasArray addObject:dict];

        }
    }else {
        if([IBOptionPlistSingleton shareIntance].groupNamesArrsy.count < 1) {
            //添加一个默认
            NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
            [mutDict setObject:CustomLocalizedString(@"ALL", nil) forKey:@"name"];
            [mutDict setObject:KAssertIds forKey:@"data"];
            [[IBOptionPlistSingleton shareIntance].groupNamesArrsy addObject:CustomLocalizedString(@"ALL", nil)];
            [IBOptionPlistSingleton shareIntance].plistDict = [mutDict copy];
            [[IBOptionPlistSingleton shareIntance].datasArray addObject:[mutDict copy]];
        }
    }
    NSDictionary *dic = [IBOptionPlistSingleton shareIntance].datasArray.firstObject;
    NSArray *dataArr = dic[@"data"];
    if (dataArr.count) {
        [self.m_SelfChooseStockArr removeAllObjects];
    }
    if (dataArr.count <= 3) {
        self.m_SelfChooseStockArr = [dataArr mutableCopy];
    }else {
        [self.m_SelfChooseStockArr addObject:dataArr.firstObject];
        [self.m_SelfChooseStockArr addObject:dataArr[1]];
        [self.m_SelfChooseStockArr addObject:dataArr[2]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate ibHomeCustomGetSelfChooseStockSuccessStatus:NO];
    });

    
    
}



//请求拿到自选股数据
-(void)requestOptionalStock {
    WEAKSELF
    [NetService().userHandler iBfetchOptionalStockShowErrorInView:nil needShowError:NO ignoreCode:nil resultBlock:^(id assetsIds, NSError *error) {
        if (!error)  {
            [[IBOptionPlistSingleton shareIntance].datasArray removeAllObjects];  //清除数据
            [[IBOptionPlistSingleton shareIntance].groupNamesArrsy removeAllObjects]; //清除所有的组名
            if (assetsIds[@"assetIds"]) //有keys 值
            {
                NSString * tempstring = assetsIds[@"assetIds"];
                id assetsArr = [IBGlobalMethod arrayWithJsonString:tempstring]; //转为字典
                NSMutableArray * responsMutArr = [NSMutableArray array];
                if (![assetsArr isKindOfClass:[NSArray class]]) {
                    return ;
                }else{
                    responsMutArr = [NSMutableArray arrayWithArray:assetsArr];
                }
                if (responsMutArr.count > 0)  {
                    for (int i=0;i<responsMutArr.count ;i++)  {
                        NSDictionary * dict = assetsArr[i];
                        NSString * name = dict[@"name"];
                        [[IBOptionPlistSingleton shareIntance].groupNamesArrsy addObject:name]; //所有的组名
                        [[IBOptionPlistSingleton shareIntance].datasArray addObject:dict];
                    }
                }
                else {
                    [weakSelf.m_SelfChooseStockArr removeAllObjects];
                    if([IBOptionPlistSingleton shareIntance].groupNamesArrsy.count<1){
                        //添加一个默认
                        NSMutableDictionary * mutDict = [NSMutableDictionary dictionary];
                        [mutDict setObject:CustomLocalizedString(@"ALL", nil) forKey:@"name"];
                        [mutDict setObject:[NSArray array] forKey:@"data"];
                        
                        [[IBOptionPlistSingleton shareIntance].groupNamesArrsy addObject:CustomLocalizedString(@"ALL", nil)];
                        [IBOptionPlistSingleton shareIntance].plistDict = [mutDict copy];
                        [[IBOptionPlistSingleton shareIntance].datasArray addObject:[mutDict copy]];
                    }
                }
                NSDictionary *dic = [IBOptionPlistSingleton shareIntance].datasArray.firstObject;
                NSArray *dataArr = dic[@"data"];
                if (dataArr.count) {
                    [weakSelf.m_SelfChooseStockArr removeAllObjects];
                }
                if (dataArr.count <= 3) {
                    weakSelf.m_SelfChooseStockArr = [dataArr mutableCopy];
                }else {
                    [weakSelf.m_SelfChooseStockArr addObject:dataArr.firstObject];
                    [weakSelf.m_SelfChooseStockArr addObject:dataArr[1]];
                    [weakSelf.m_SelfChooseStockArr addObject:dataArr[2]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.delegate ibHomeCustomGetSelfChooseStockSuccessStatus:YES];
                });
                
            } else {
                    [weakSelf.delegate ibHomeCustomGetSelfChooseStockSuccessStatus:YES];
            }
        }
    }];
}



- (void)getSelfChooseStockViewWillAppear {
    if ([IBXHelpers getNetWorkStatus] == 0) {
        [self.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
        return;
    }
    
    NSDictionary *dic = [IBOptionPlistSingleton shareIntance].datasArray.firstObject;
    NSArray *dataArr = dic[@"data"];
    if (dataArr.count) {
        [self.m_SelfChooseStockArr removeAllObjects];
    }
    if (dataArr.count == 0) {
        [self.m_SelfChooseStockArr removeAllObjects];
        [self.delegate ibHomeCustomGetSelfChooseStockSuccessStatus:YES];

        return;
    }
    if (dataArr.count <= 3 && dataArr.count > 0 ) {
        self.m_SelfChooseStockArr = [dataArr mutableCopy];
    }else {
        [self.m_SelfChooseStockArr addObject:dataArr.firstObject];
        [self.m_SelfChooseStockArr addObject: dataArr[1]];
        [self.m_SelfChooseStockArr addObject:dataArr[2]];
        
    }

    [self.delegate ibHomeCustomGetSelfChooseStockSuccessStatus:YES];
}







#pragma mark    预废弃
///通用的获取数据外设接口
- (void)getDataWithView:(UIView *)view withGetDataType:(HomeMainModelGetDataType)type withSectionTag:(NSInteger)section{
    if ([IBXHelpers getNetWorkStatus] == 0) {
        [self.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
        return;
    }

    if (section == 1) {///财富百科
        if (type == HomeMainModelGetDataTypeDefault) {
            self.m_PropertyPageNum = 1;
            NSString *pageIndex = [@(self.m_PropertyPageNum )stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [self getPropertyWithPara:params withView:view withType:HomeMainModelGetDataTypeDefault];
            
            
        }else if (type == HomeMainModelGetDataTypeRefresh) {
            self.m_PropertyPageNum = 1;
            NSString *pageIndex = [@(self.m_PropertyPageNum )stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [self getPropertyWithPara:params withView:view withType:HomeMainModelGetDataTypeRefresh];
            
        }else {
            NSString *pageIndex = [@(self.m_PropertyPageNum + 1)stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [self getPropertyWithPara:params withView:view withType:HomeMainModelGetDataTypeLoadMore];
        }
    }else if(section == 0) {///市场动态
        if (type == HomeMainModelGetDataTypeDefault) {
            self.m_MarketPageNum = 1;
            NSString *pageIndex = [@(self.m_MarketPageNum )stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [params setObject:@"9" forKey:@"type"];
            [self getInfomationTitleRequestWithPara:params withView:view withType:HomeMainModelGetDataTypeDefault];
            
            
        }else if (type == HomeMainModelGetDataTypeRefresh) {
            self.m_MarketPageNum = 1;
            NSString *pageIndex = [@(self.m_MarketPageNum )stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [params setObject:@"9" forKey:@"type"];

            [self getInfomationTitleRequestWithPara:params withView:view withType:HomeMainModelGetDataTypeRefresh];
            
        }else {
            NSString *pageIndex = [@(self.m_MarketPageNum + 1)stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [params setObject:@"9" forKey:@"type"];

            [self getInfomationTitleRequestWithPara:params withView:view withType:HomeMainModelGetDataTypeLoadMore];
        }

        
    }else {///股票评级
        if (type == HomeMainModelGetDataTypeDefault) {
            self.m_StockLevelNum = 1;
            NSString *pageIndex = [@(self.m_StockLevelNum )stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [params setObject:@"8" forKey:@"type"];
            [self getStockLevelRateWithPara:params withView:view withType:HomeMainModelGetDataTypeDefault];
            
            
        }else if (type == HomeMainModelGetDataTypeRefresh) {
            self.m_StockLevelNum = 1;
            NSString *pageIndex = [@(self.m_StockLevelNum )stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [params setObject:@"8" forKey:@"type"];
            
            [self getStockLevelRateWithPara:params withView:view withType:HomeMainModelGetDataTypeRefresh];
            
        }else {
            NSString *pageIndex = [@(self.m_StockLevelNum + 1)stringValue];
            NSString *pageSize = @"20";
            NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
            [params setObject:pageIndex forKey:@"pageIndex"];
            [params setObject:pageSize forKey:@"pageSize"];
            [params setObject:@"8" forKey:@"type"];
            
            [self getStockLevelRateWithPara:params withView:view withType:HomeMainModelGetDataTypeLoadMore];
        }
    }
}




///股票评级
- (void)getStockLevelRateWithPara:(NSDictionary *)para withView:(UIView *)view withType:(HomeMainModelGetDataType)type {
    WEAKSELF
    [self qnPostPath:@"get_news_tablist" parameters:[self requestJsonDicWithParams:para] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       id data = responseObject[@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            data = (NSDictionary *)data;
            
        }else {
            [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:[IBXHelpers getErrorInforWithString:responseObject[@"message"]]];
            return ;
        }
        if ([[data allKeys] containsObject:@"list"]) {
            id list = data[@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                if (type == HomeMainModelGetDataTypeDefault || type == HomeMainModelGetDataTypeRefresh) {
                    [weakSelf.CacheStockLevelArr removeAllObjects];
                    [weakSelf.CacheStockLevelArr addObjectsFromArray:list];
                    [iBestCache() setCacheWithArray:weakSelf.CacheStockLevelArr withKey:CacheStockLevelRate];
                    [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
                }else {
                    weakSelf.m_StockLevelNum ++;
                    weakSelf.m_StockLevleFlag = weakSelf.CacheStockLevelArr.count;
                    [weakSelf.CacheStockLevelArr addObjectsFromArray:list];
                    [iBestCache() setCacheWithArray:weakSelf.CacheStockLevelArr withKey:CacheStockLevelRate];
                    if (weakSelf.m_MarketFlag == weakSelf.CacheStockLevelArr.count) {
                    }
                    [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
                }
            }else {
                [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
            }
        }else  if([[data allKeys] containsObject:@"EX01"]){
            [weakSelf.CacheStockLevelArr removeAllObjects];
            //NSDictionary *ex01 = data[@"EX01"];
            //NSString *infor = [IBXHelpers getStringWithDictionary:ex01 andForKey:@"ESUB"] ;
            [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
        }else  if([[data allKeys] containsObject:@"CHEX"]){
            [weakSelf.CacheStockLevelArr removeAllObjects];
            id CHEX = data[@"CHEX"];
            if ([CHEX isKindOfClass:[NSDictionary class]]) {
                NSString *code = [IBXHelpers getStringWithDictionary:CHEX andForKey:@"ESUB"];
                //NSString *infor = [IBXHelpers  getTradeRequestInforWithCode:code];
                if ([code  isEqual: @"-2"]) {
                }else {
                }
                [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
            }
        }else {
            [weakSelf.CacheStockLevelArr removeAllObjects];
            //NSString *infor = responseObject[@"message"];
            [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
        }
        
        NSLog(@"%@_______-获取股票评级成功", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
    }];
}







///获取财富资讯
- (void)getPropertyWithPara:(NSDictionary *)para withView:(UIView *)view withType:(HomeMainModelGetDataType)type{
    WEAKSELF
    [self qnPostPath:@"get_caifuzixun" parameters:[self requestJsonDicWithParams:para] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *result = responseObject[@"result"];
        if ([[responseObject allKeys] containsObject:@"data"]) {
            id data = responseObject[@"data"];
            if ([data isKindOfClass:[NSArray class]]) {
                if (type == HomeMainModelGetDataTypeDefault || type == HomeMainModelGetDataTypeRefresh) {
                    [weakSelf.CacheCaiFuZiXunArr removeAllObjects];
                    [weakSelf.CacheCaiFuZiXunArr addObjectsFromArray:data];
                    [iBestCache() setCacheWithArray:weakSelf.CacheCaiFuZiXunArr withKey:CacheHomeCaiFuZiXun];

                    [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
                }else {
                    weakSelf.m_PropertyPageNum ++;
                    weakSelf.m_PropertyFlag = weakSelf.CacheCaiFuZiXunArr.count;
                    [weakSelf.CacheCaiFuZiXunArr addObjectsFromArray:data];
                    [iBestCache() setCacheWithArray:weakSelf.CacheCaiFuZiXunArr withKey:CacheHomeCaiFuZiXun];

                    if (weakSelf.m_PropertyFlag == weakSelf.CacheCaiFuZiXunArr.count) {
                        [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
                    } 
                }
            }else {
                [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
            }
        }else  if([[responseObject allKeys] containsObject:@"EX01"]){
            [weakSelf.CacheCaiFuZiXunArr removeAllObjects];
            NSDictionary *ex01 = result[@"EX01"];
            NSString *infor = [IBXHelpers getStringWithDictionary:ex01 andForKey:@"ESUB"] ;
            [weakSelf.delegate ibHomeCustomGetDataFailedWithInfor:infor];
        }else  if([[responseObject allKeys] containsObject:@"CHEX"]){
            [weakSelf.CacheCaiFuZiXunArr removeAllObjects];
            id CHEX = result[@"CHEX"];
            if ([CHEX isKindOfClass:[NSDictionary class]]) {
                NSString *code = [IBXHelpers getStringWithDictionary:CHEX andForKey:@"ESUB"];
                NSString *infor = [IBXHelpers  getTradeRequestInforWithCode:code];
                if ([code  isEqual: @"-2"]) {
                    [weakSelf.delegate ibHomeCustomGetDataFailedWithInfor:CustomLocalizedString(@"TRADE_DENGLUGUOQIQINGCHONGXINDENGLU", nil)];
                }else {
                    [weakSelf.delegate ibHomeCustomGetDataFailedWithInfor:infor];
                }
            }
        }else {
            [weakSelf.CacheCaiFuZiXunArr removeAllObjects];
            NSString *infor = responseObject[@"message"];
            [weakSelf.delegate ibHomeCustomGetDataFailedWithInfor:infor];
        }
        NSLog(@"%@______获取财富资讯成功", responseObject);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.delegate ibHomeCustomGetDataFailedWithInfor:@""];
        NSLog(@"%@___%@____获取财富资讯失败", error, task);
    }];
}



///获取市场动态
-(void)getInfomationTitleRequestWithPara:(NSDictionary *)para withView:(UIView *)view  withType:(HomeMainModelGetDataType)type {
    WEAKSELF
    [self qnPostPath:@"get_news_tablist" parameters:[self requestJsonDicWithParams:para] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *data = responseObject[@"data"];
        if ([[data allKeys] containsObject:@"list"]) {
            id list = data[@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                if (type == HomeMainModelGetDataTypeDefault || type == HomeMainModelGetDataTypeRefresh) {
                    [weakSelf.CacheShiChangDongTaiArr removeAllObjects];
                    [weakSelf.CacheShiChangDongTaiArr addObjectsFromArray:list];
                    [iBestCache() setCacheWithArray:weakSelf.CacheShiChangDongTaiArr withKey:CacheHomeShiChangDongTai];
                    [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
                }else {
                    weakSelf.m_MarketPageNum ++;
                    weakSelf.m_MarketFlag = weakSelf.CacheShiChangDongTaiArr.count;
                    [weakSelf.CacheShiChangDongTaiArr addObjectsFromArray:list];
                    [iBestCache() setCacheWithArray:weakSelf.CacheShiChangDongTaiArr withKey:CacheHomeShiChangDongTai];
                    if (weakSelf.m_MarketFlag == weakSelf.CacheShiChangDongTaiArr.count) {
                    }
                    [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
                }
            }else {
                [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
            }
        }else  if([[data allKeys] containsObject:@"EX01"]){
            [weakSelf.CacheShiChangDongTaiArr removeAllObjects];
            //NSDictionary *ex01 = data[@"EX01"];
            //NSString *infor = [IBXHelpers getStringWithDictionary:ex01 andForKey:@"ESUB"] ;
            [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
        }else  if([[data allKeys] containsObject:@"CHEX"]){
            [weakSelf.CacheShiChangDongTaiArr removeAllObjects];
            id CHEX = data[@"CHEX"];
            if ([CHEX isKindOfClass:[NSDictionary class]]) {
                NSString *code = [IBXHelpers getStringWithDictionary:CHEX andForKey:@"ESUB"];
                //NSString *infor = [IBXHelpers  getTradeRequestInforWithCode:code];
                if ([code  isEqual: @"-2"]) {
                }else {
                }
                [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
            }
        }else {
            [weakSelf.CacheShiChangDongTaiArr removeAllObjects];
            //NSString *infor = responseObject[@"message"];
            [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
        }
        
        NSLog(@"%@_______-获取市场动态成功", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.delegate ibHomeCustomGetDataSuccessWithInfor:@""];
    }];
}



#pragma mark    V1.2.0版本后  获取iBest精选资讯

///获取iBest热门资讯
- (void)getChoicenessInformationWithView:(UIView *)view withType:(HomeMainModelGetDataType)type {
    NSMutableDictionary *params = [IBXHelpers getSignIBestRequestWithSession];
    [params setObject:@"20" forKey:@"pageSize"];
    
    if (type == HomeMainModelGetDataTypeDefault || type == HomeMainModelGetDataTypeRefresh) {
        self.m_InformationPage = 1;
        [params setObject:[@(self.m_InformationPage)stringValue] forKey:@"pageIndex"];
    }else {
        [params setObject:[@(self.m_InformationPage + 1)stringValue] forKey:@"pageIndex"];
    }
    [self getInformationWithType:type withView:view withPara:params];
}

- (void)getInformationWithType:(HomeMainModelGetDataType)type withView:(UIView *)view withPara:(NSDictionary *)para {
    WEAKSELF
    [self qnPostPath:@"get_ibest_selection" parameters:[self requestJsonDicWithParams:para] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id data = responseObject[@"data"];
        if ([data isKindOfClass:[NSArray class]]) {
            if (type == HomeMainModelGetDataTypeDefault || type == HomeMainModelGetDataTypeRefresh) {
                [weakSelf.m_InformationArr removeAllObjects];
                [weakSelf.m_InformationArr addObjectsFromArray:data];
                [weakSelf sortArrWithStatus:weakSelf.m_InformationArr withInfor:@""];
            }else {
                weakSelf.m_InformationFlag = weakSelf.m_InformationArr.count;
                weakSelf.m_InformationPage ++ ;
                [weakSelf.m_InformationArr addObjectsFromArray:data];
                
                if (weakSelf.m_InformationFlag == weakSelf.m_InformationArr.count) {
                    [weakSelf sortArrWithStatus:weakSelf.m_InformationArr withInfor:CustomLocalizedString(@"HOME_DANGQIANWUGENGDUOSHUJU", nil)];
                }else {
                    [weakSelf sortArrWithStatus:weakSelf.m_InformationArr withInfor:@""];
                }
            }
        }else {
            [weakSelf.m_InformationArr removeAllObjects];
            [weakSelf.delegate ibHomeCustomGetDataFailedWithInfor:@""];
        }
        NSLog(@"%@__________首页获取热门资讯成功", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.delegate ibHomeCustomGetDataFailedWithInfor:KNetWork_Error];
    }];
}

///资讯中status != 1筛选出去
- (void)sortArrWithStatus:(NSArray *)arr withInfor:(NSString *)infor{
    NSMutableArray *muArr = [arr mutableCopy];
    for (id information in arr) {
        if ([information isKindOfClass:[NSDictionary class]]) {
            NSString *status = [IBXHelpers getStringWithDictionary:information andForKey:@"status"];
            if (![status isEqualToString:@"1"]) {
                [muArr removeObject:information];
            }
        }
    }
    self.m_InformationArr = muArr;
    [self.delegate ibHomeCustomGetDataSuccessWithInfor:infor];
}






#pragma mark    获取未读消息操作

- (void)getUnreadMessageActionWithView:(UIView *)view {
    if (![IBGlobalMethod isLogin]) {
        return;
    }
    //HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
//    if (conversation.unreadMessagesCount > 0) {
//        [self.delegate ibUnReadMessagesSuccessWithCount:conversation.unreadMessagesCount];
//        return;
//    }
    
    WEAKSELF
    [NetService().userHandler iBESTFetchSystemMessageWith:ibMsgHandler().systemUnReadMessageVersion showErrorInView:view needShowError:NO ignoreCode:nil resultBlock:^(NSArray *messages, int64_t version) {
      
        HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
        NSUInteger messageCount;
        if(messages.count) {
            messageCount  = ibMsgHandler().systemUnReadMessageCount + conversation.unreadMessagesCount+ messages.count;
        } else  {
            messageCount  = ibMsgHandler().systemUnReadMessageCount + conversation.unreadMessagesCount;
        }
        [weakSelf.delegate ibUnReadMessagesSuccessWithCount:messageCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (messageCount > 0) {
                App().rootTabbarVC.tabBar.items.firstObject.badgeValue = [@(messageCount) stringValue];
            }else {
                App().rootTabbarVC.tabBar.items.firstObject.badgeValue = nil;
            }
        });
    } failedBlock:^(NSString *infor) {
        ///暂不处理
//        HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
//        NSUInteger messageCount;
//        if(!error) {
//            messageCount  = ibMsgHandler().systemUnReadMessageCount + conversation.unreadMessagesCount+ messages.count;
//        } else  {
//            messageCount  = ibMsgHandler().systemUnReadMessageCount + conversation.unreadMessagesCount;
//        }
//        [weakSelf.delegate ibUnReadMessagesSuccessWithCount:messageCount];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (messageCount > 0) {
//                App().rootTabbarVC.tabBar.items.firstObject.badgeValue = [@(messageCount) stringValue];
//            }else {
//                App().rootTabbarVC.tabBar.items.firstObject.badgeValue = nil;
//            }
//        });
    }];
    
    
//    [NetService().userHandler iBESTFetchSystemMessageWith:ibMsgHandler().systemUnReadMessageVersion showErrorInView:view needShowError:NO ignoreCode:nil resultBlock:^(NSArray *messages, int64_t version, NSError *error) {
//        HConversation *conversation = [[HChatClient sharedClient].chat getConversation:HXKF_IM_SERVER_NUM];
//        NSUInteger messageCount;
//        if(!error) {
//            messageCount  = ibMsgHandler().systemUnReadMessageCount + conversation.unreadMessagesCount+ messages.count;
//        } else  {
//            messageCount  = ibMsgHandler().systemUnReadMessageCount + conversation.unreadMessagesCount;
//        }
//        [weakSelf.delegate ibUnReadMessagesSuccessWithCount:messageCount];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (messageCount > 0) {
//                App().rootTabbarVC.tabBar.items.firstObject.badgeValue = [@(messageCount) stringValue];
//            }else {
//                App().rootTabbarVC.tabBar.items.firstObject.badgeValue = nil;
//            }
//        });
//    }];
}



#pragma mark    Case

- (NSMutableArray *)m_SelfChooseStockArr {
    if (!_m_SelfChooseStockArr) {
        _m_SelfChooseStockArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _m_SelfChooseStockArr;
}



//- (NSArray *)m_SelfChooseStockArr {
//    if ([IBXHelpers getNetWorkStatus] == 0) {
//        if (_m_SelfChooseStockArr.count) {
//            return _m_SelfChooseStockArr;
//        }else {
//            _m_SelfChooseStockArr = [iBestCache() getCacheArrayWithKey:CacheSelfChooseStock];
//            return _m_SelfChooseStockArr.count > 0? _m_SelfChooseStockArr : @[];
//        }
//    }
//    return self.CacheChooseStocksArr;
//}




- (NSArray *)m_PropertyMessageArr {
    if ([IBXHelpers getNetWorkStatus] == 0) {
        if (_m_PropertyMessageArr.count) {
            return _m_PropertyMessageArr;
        }else {
            _m_PropertyMessageArr = [iBestCache() getCacheArrayWithKey:CacheHomeCaiFuZiXun];
            return _m_PropertyMessageArr.count > 0? _m_PropertyMessageArr : @[];
        }

    }
    return self.CacheCaiFuZiXunArr;

}

//- (NSArray *)m_TurnImageArr {
//    if ([IBXHelpers getNetWorkStatus] == 0) {
//        if (_m_TurnImageArr.count) {
//            return _m_TurnImageArr;
//        }else {
//            _m_TurnImageArr = [iBestCache() getCacheArrayWithKey:CacheHomeTurnImage];
//            if (_m_TurnImageArr.count) {
//                return _m_TurnImageArr;
//            }else {
//                return  @[[UIImage imageNamed:@"home01"], [UIImage imageNamed:@"home02"], [UIImage imageNamed:@"home03"]];
//            }
//        }
//    }
//    return self.CacheTurnImageArr;
//
//}


- (NSArray *)m_TurnImageArr {
    if (!_m_TurnImageArr) {
        _m_TurnImageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _m_TurnImageArr;
}





- (NSArray *)m_MarketActivityArr {
    if ([IBXHelpers getNetWorkStatus] == 0) {
        if (_m_MarketActivityArr.count ) {
            return _m_MarketActivityArr;
        }else {
           _m_MarketActivityArr = [iBestCache() getCacheArrayWithKey:CacheHomeShiChangDongTai];
            return _m_MarketActivityArr.count > 0? _m_MarketActivityArr : @[];
        }
    }
  return self.CacheShiChangDongTaiArr;
}



- (NSArray *)m_StockLevelArr {
    if ([IBXHelpers getNetWorkStatus] == 0) {
        if (_m_StockLevelArr.count) {
            return _m_StockLevelArr;
        }else {
            _m_StockLevelArr = [iBestCache() getCacheArrayWithKey:CacheStockLevelRate];
            return _m_StockLevelArr.count > 0? _m_StockLevelArr : @[];
        }
    }
    return self.CacheStockLevelArr;
}



#pragma mark   Getter

- (NSMutableArray *)m_InformationArr {
    if (!_m_InformationArr) {
        _m_InformationArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _m_InformationArr;
}

- (NSArray *)m_ReadedNewsArr {
    if (_m_ReadedNewsArr .count) {
        return _m_ReadedNewsArr;
    }else {
        NSArray *arr = [IBTradeSingleTon shareTradeSingleTon].m_ReadedNewsArr;
        _m_ReadedNewsArr = arr;
        return arr;
    }
}



- (NSMutableArray *)CacheCaiFuZiXunArr  {
    if (!_CacheCaiFuZiXunArr) {
        _CacheCaiFuZiXunArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _CacheCaiFuZiXunArr;
}

- (NSMutableArray *)CacheReMenZiXUnArr {
    if (!_CacheReMenZiXUnArr) {
        _CacheReMenZiXUnArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _CacheReMenZiXUnArr;
}


- (NSMutableArray *)CacheShiChangDongTaiArr {
    if (!_CacheShiChangDongTaiArr) {
        _CacheShiChangDongTaiArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _CacheShiChangDongTaiArr;
}


- (NSMutableArray *)CacheTurnImageArr {
    if (!_CacheTurnImageArr) {
        _CacheTurnImageArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _CacheTurnImageArr;
}

//- (NSMutableArray *)CacheChooseStocksArr {
//    if (!_CacheChooseStocksArr) {
//        _CacheChooseStocksArr = [NSMutableArray arrayWithCapacity:0];
//    }
//    return _CacheChooseStocksArr;
//}

- (NSMutableArray *)CacheStockLevelArr {
    if (!_CacheStockLevelArr) {
        _CacheStockLevelArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _CacheStockLevelArr;
}





@end
