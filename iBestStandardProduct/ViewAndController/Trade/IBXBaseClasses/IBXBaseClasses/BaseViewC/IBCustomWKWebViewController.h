//
//  IBCustomWKWebViewController.h
//  QNApp
//  一个简单的, 单纯的加载一个链接的wkWebView!!!如果做其他操作,重新创建
//  Created by xboker on 2017/4/22.
//  Copyright © 2017年 BaiCai. All rights reserved.
//

#import "YHQBaseViewController.h"

typedef NS_ENUM(NSInteger, CustomWKWebViewType) {
    ///首页中轮播图的跳转
    CustomWKWebViewTypeHomeTurnType = 0,
    ///首页中财富资讯的跳转
    CustomWKWebViewTypeCaiFuZiXun,
    ///热门资讯(首页下面的咨询)
    CustomWKWebViewTypeChoicenessInformation,
    ///登录时的免责声明
    CustomWKWebViewTypeMZSM,
    ///其他情况
    CustomWKWebViewTypeOther,
    ///开户
    CustomWKWebViewTypeOpenTradeAccount,
    ///存款转账凭证要求
    CustomWKWebViewTypeCKZZ,
    //内地开户网点
    CustomWKWebViewTypeNDKHWD,
    //内地见证开户网点
    CustomWKWebViewTypeNDJZKHWD,
    ///申请指南
    CustomWKWebViewTypeSQZN,
    ///操作指南
    CustomWKWebViewTypeCZZN,
    ///服务收费表
    CustomWKWebViewTypeFWSFB,
    ///建行账户简介
    CustomWKWebViewTypeJHZHJJ,
    ///招行账户简介
    CustomWKWebViewTypeZHZHJJ,
    ///工行账户简介
    CustomWKWebViewTypeGHZHJJ,
    ///交易类型盘说明
    CustomWKWebViewTypeTradeTypeInfor,
    ///获取LV2
    CustomWKWebViewTypeLV2Protocol,
    ///公司简介
    CustomWKWebViewTypeCompanyIntroduce,
    ///个人资料
    CustomWKWebViewTypeMyInfo,
    ///安全须知
    CustomWKWebViewTypeSaftyNeed,
    ///参考本公司通知
    CustomWKWebViewTypeCKBGSTZ,
    ///串流报价简介
    CustomWKWebViewTypeCLBJJJ,
    ///找回交易密码时风险披露
    CustomWKWebViewTypeFXPL,
    ///交易登录两步认证时查看  结单服务表格
    CustomWKWebViewTypeJDFWBG,
    
    
};



@interface IBCustomWKWebViewController : YHQBaseViewController


@property (nonatomic, assign) CustomWKWebViewType   m_LoadType;
@property (nonatomic, copy)   NSString              *m_LoadUrl;
@property (nonatomic, strong) NSString              *m_TitleStr;
@property (nonatomic, strong) NSDictionary          *m_MessageDic;





@end
