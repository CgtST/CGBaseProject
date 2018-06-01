//
//  IBOptionalStock.h
//  iBestStandard
//
//  Created by bingo on 2018/5/15.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  自选股对象
 */

typedef NS_ENUM(int8_t, IBOptionalStockDisplayType) {
    IBOptionalStockDisplayTypeChangePercent,  //涨跌幅
    IBOptionalStockDisplayTypeChangeValue, //涨跌额
    IBOptionalStockDisplayTypeTotalValue //市值
};

@interface IBOptionalStock : NSObject




/**
 *  用于请求盘口的字段
 *
 *  @return 字段字符串
 */
+ (NSString *)Fields;

/**
 *  资产ID
 */
@property (strong, nonatomic, readwrite) NSString *assetId;
/**
 *  用于显示的股票代码
 */
@property (strong, nonatomic, readwrite) NSString *assetCode;
/**
 *  资产名
 */
@property (strong, nonatomic, readwrite) NSString *name;
/**
 *  现价
 */
@property (strong, nonatomic, readwrite) NSString *price;

/**
 *  涨跌
 */
@property (strong, nonatomic, readwrite) NSString *change;
/**
 *  涨跌幅
 */
@property (strong, nonatomic, readwrite) NSString *changePercent;
/**
 *  总市值
 */
@property (strong, nonatomic, readwrite) NSString *totalValue;
/**
 *  证券子类型
 */
@property (strong, nonatomic, readwrite) NSString *sType;
/**
 *  是否已经上传
 */
@property (nonatomic) BOOL uploaded;
/**
 *  创建时间戳
 */
@property (nonatomic) int64_t createdTs;

/**
 *  股票状态
 */
@property (nonatomic, readwrite) IBStockTradeStatus status;
/**
 *  股票状态标示字符串
 */
@property (strong, nonatomic, readwrite) NSString *statusIdentifier;

/**
 *  单位交易量 add by chargo
 */
@property (strong, nonatomic, readwrite) NSString *lotSize;

@property (nonatomic) BOOL bDelay;  //是实时还是延时的标志

- (instancetype)initWithParams:(NSArray *)params bDelay:(BOOL) bdelay;

+ (instancetype)UndefinedStockWithAssetId:(NSString *)assetId name:(NSString *)name;

- (void)setupWithParams:(NSArray *)params bDelay:(BOOL) bdelay;

@property (nonatomic) IBOptionalStockDisplayType displayType;

@property (nonatomic) NSInteger sortIndex;
/**
 *  切换到下一个显示内容
 */
- (void)nextDisplayType;


//其它的模型转自选股
-(instancetype)initwithOtherModel:(NSArray *)array;

@end
