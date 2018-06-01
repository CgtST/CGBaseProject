//
//  IBNewStockRuleViewController.h
//  QNApp
//
//  Created by iBest on 2017/5/24.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "YHQBaseViewController.h"

typedef NS_ENUM (NSInteger,RulerType)
{
    RulerType_HTNewStock = 0,//海通国际新股认购章程
    RulerType_NewStockRisk,//新股申购风险披露
    RulerType_NewStockDetail, //新股申购条款及细则
    RulerType_TradeloginRisk, //交易登录中的免责声明
    RulerType_YHTK,//用户条款
    RulerType_AQXZ,//安全需知
};

@interface IBNewStockRuleViewController : YHQBaseViewController

@property (nonatomic,copy)NSString * mtitle;

@property(nonatomic) RulerType type;
-(instancetype)initWithUrl:(NSString *)url;


@end
