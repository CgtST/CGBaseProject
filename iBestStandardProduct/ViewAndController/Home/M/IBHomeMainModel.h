//
//  IBHomeMainModel.h
//  QNApp
//
//  Created by xboker on 2017/4/21.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "QNBaseHttpClient.h"


typedef NS_ENUM(NSInteger, HomeMainModelGetDataType) {
    HomeMainModelGetDataTypeDefault = 1,
    HomeMainModelGetDataTypeRefresh,
    HomeMainModelGetDataTypeLoadMore
};


@protocol IBHomeMainModelDelegate <NSObject>
@required
///通用获取信息成功回调
- (void)ibHomeCustomGetDataSuccessWithInfor:(NSString *)infor;

///通用获取信息失败回调
- (void)ibHomeCustomGetDataFailedWithInfor:(NSString *)infor;
///获取轮播图成功回调
- (void)ibHomeCustomGetHomeTurnImageSuccessWithInFor:(NSString *)infor;
///获取自选股成功回调
- (void)ibHomeCustomGetSelfChooseStockSuccessStatus:(BOOL)isGet;
///获取未读消息条数
- (void)ibUnReadMessagesSuccessWithCount:(NSInteger )count;

@end


@interface IBHomeMainModel : QNBaseHttpClient


///是否已经读过的新闻id数组
@property (nonatomic, strong) NSArray *m_ReadedNewsArr;

///里面全是一个个的自选的assertID
@property (nonatomic, strong) NSMutableArray *m_SelfChooseStockArr;

///轮播图的数组
@property (nonatomic, strong) NSMutableArray *m_TurnImageArr;

///iBest热门资讯数组
@property (nonatomic, strong) NSMutableArray *m_InformationArr;

#pragma mark    首页资讯三合一, 以下预废弃
///财富百科数组
@property (nonatomic, strong) NSArray *m_PropertyMessageArr;
///市场动态
@property (nonatomic, strong) NSArray *m_MarketActivityArr;
///股票评级
@property (nonatomic, strong) NSArray *m_StockLevelArr;

///预废弃
- (void)getDataWithView:(UIView *)view withGetDataType:(HomeMainModelGetDataType)type withSectionTag:(NSInteger)section;

#pragma mark    首页资讯三合一, 以上预废弃






@property (nonatomic, weak) id<IBHomeMainModelDelegate>delegate;


- (void)getTurnImageActionWithView:(UIView *)view;
///界面加载时发一次请求
- (void)getSelfChooseStockAction;
///以后每次界面出现的时候默认从单例里面取出最新的
- (void)getSelfChooseStockViewWillAppear;
///获取iBest热门资讯
- (void)getChoicenessInformationWithView:(UIView *)view withType:(HomeMainModelGetDataType)type;






@property (nonatomic, assign) NSInteger m_UnreadMessageCount;
///首页获取未读消息, 如果有未读消息显示红点
- (void)getUnreadMessageActionWithView:(UIView *)view;












@end
