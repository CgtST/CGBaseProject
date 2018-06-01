//
//  IBUserCustomHandleModel.h
//  iBestProduct
//  User相关的通用Model
//  Created by xboker on 2017/11/29.
//  Copyright © 2017年 iBest. All rights reserved.
//
//此类禁止创建!!!!!--直接用   ibUserHandler()



#import "QNBaseHttpClient.h"

typedef NS_ENUM(NSInteger, ShareType) {
    ///banner里面点击分享
    ShareType_Banner = 0,
    ///资讯
    ShareType_ZiXun = 1,
    ///24消失资讯
    ShareType_24Hours = 2,
    ///首页热门自选
    ShareType_Home_ZiXun,
};


@interface IBUserCustomHandleModel : QNBaseHttpClient





/**
 用ShareSDK底部弹出界面进行分享资讯

 @param messageDic 某条资讯的信息包
 @param view 在哪个View上显示
 @param type banner或者资讯
 @param shareResult 分享的结果
 */
- (void)shareMessageWithDictionary:(NSDictionary *)messageDic withView:(UIView *)view withType:(ShareType)type withCallBack:(void(^)(NSString *inforStr))shareResult;








/**
 tabbar->资讯详情界面获取可分享的资讯内容
 
 @param newID 资讯ID
 @param newType 资讯类型
 @param view 展示信息的view
 @param getResult 将请求获取到的连接返回, 如果为空则认为请求失败,不提示结果
 */
- (void)getNewsShareDetailWithNewID:(NSString *)newID withNewType:(NSString *)newType withView:(UIView *)view withGetUrl:(void(^)(NSString *shareUrl))getResult;





@end

