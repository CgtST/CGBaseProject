//
//  IBUserCustomHandleModel.m
//  iBestProduct
//
//  Created by xboker on 2017/11/29.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBUserCustomHandleModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIEditorViewStyle.h>




@implementation IBUserCustomHandleModel

-(instancetype)init {
    self = [super initWithBaseURL: QN_SSL_USER_BASE_URL]; 
    if (self) {
        
    }
    return self;
}




/**
 用ShareSDK底部弹出界面进行分享资讯
 
 @param messageDic 某条资讯的信息包
 @param view 在哪个View上显示
 @param type banner或者资讯
 @param shareResult 分享的结果
 */
- (void)shareMessageWithDictionary:(NSDictionary *)messageDic withView:(UIView *)view withType:(ShareType)type withCallBack:(void(^)(NSString *inforStr))shareResult {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *infoTitle;
    NSString *url;
    NSString *des ;
    if (type == ShareType_ZiXun) {
        des = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"infoTitle"];
        infoTitle = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"infoTitle"];
        url = [[IBXHelpers getStringWithDictionary:messageDic andForKey:@"url"] stringByAppendingString:@"?key=1"];
        if (url.length < 8) {
            url = [[IBXHelpers getStringWithDictionary:messageDic andForKey:@"argi"] stringByAppendingString:@"?key=1"];
        }
    }
    if (type == ShareType_Banner) {
        des = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"headtitle"];
        infoTitle = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"headtitle"];
        url = [[IBXHelpers getStringWithDictionary:messageDic andForKey:@"url"] stringByAppendingString:@"?key=1"];
        if (url.length < 8) {
            url = [[IBXHelpers getStringWithDictionary:messageDic andForKey:@"argi"] stringByAppendingString:@"?key=1"];
        }
    }
    if (type == ShareType_24Hours) {
        des = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"content"];
        infoTitle = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"infoTitle"];
        url = [[IBXHelpers getStringWithDictionary:messageDic andForKey:@"url"] stringByAppendingString:@"?key=1"];
    }
    if (type == ShareType_Home_ZiXun) {
        des = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"infoTitle"];
        infoTitle = [IBXHelpers getStringWithDictionary:messageDic andForKey:@"infoTitle"];
        url = [[IBXHelpers getStringWithDictionary:messageDic andForKey:@"url"] stringByAppendingString:@"?key=1"];
    }
    if (des.length < 1) {
        des = infoTitle;
    }
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    [shareParams SSDKSetupShareParamsByText:des
                                     images:@[@"http://s.ibestfin.com.cn/app/caifu/img/5a1e7a926fb6c.png"]
                                        url:[NSURL URLWithString:url]
                                      title:infoTitle
                                       type:SSDKContentTypeAuto];
    [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:232/255.0 green:212/255.0 blue:212/255.0 alpha:0.5]];
    [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1]];
    [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:242/255.0 green:250/255.0 blue:242/255.0 alpha:1]];
    [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor blackColor]];
    [SSUIShareActionSheetStyle setItemNameColor:[UIColor darkGrayColor]];
    [SSUIShareActionSheetStyle setItemNameFont:[UIFont systemFontOfSize:11]];
    [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor blackColor]];
    [SSUIEditorViewStyle setTitleColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setCancelButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setShareButtonLabelColor:[UIColor whiteColor]];
    [SSUIEditorViewStyle setStatusBarStyle:UIStatusBarStyleLightContent];
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSystem];
    [ShareSDK showShareActionSheet:view items:@[@(SSDKPlatformSubTypeWechatSession),
                                                @(SSDKPlatformSubTypeWechatTimeline),
                                                @(SSDKPlatformSubTypeQQFriend)]
                       shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                           switch (state) {
                               case SSDKResponseStateSuccess: {
                                   switch (platformType) {
                                       case SSDKPlatformSubTypeQQFriend: {
                                           [MobClick event:@"shared" label:@"qq"];
                                           break;
                                       }
                                       case SSDKPlatformSubTypeWechatSession: {
                                           [MobClick event:@"shared" label:@"wechat_friend"];
                                           break;
                                       }
                                       case SSDKPlatformSubTypeWechatTimeline: {
                                           [MobClick event:@"shared" label:@"wechat_wall"];
                                           break;
                                       }
                                           
                                       default:
                                           break;
                                   }
                                   shareResult(CustomLocalizedString(@"MINEFENXIANGCHENGGONG", nil));
                                   break;
                               }
                               case SSDKResponseStateFail: {
                                   if (error.code == 105) {
                                       shareResult(CustomLocalizedString(@"FX_BU_FENXIANGPINGTAIXUYAOQQWEIXINCAINENGFENXIANG", nil));
                                   }else {
                                       shareResult(CustomLocalizedString(@"MINEFENXIANGSHIBAI", nil));
                                   }
                                   break;
                               }
                               default:
                                   break;
                           }
                       }];
}





/**
 tabbar->资讯详情界面获取可分享的资讯内容
 
 @param newID 资讯ID
 @param newType 资讯类型
 @param view 展示信息的view
 @param getResult 将请求获取到的连接返回, 如果为空则认为请求失败,不提示结果
 */
- (void)getNewsShareDetailWithNewID:(NSString *)newID withNewType:(NSString *)newType withView:(UIView *)view withGetUrl:(void(^)(NSString *shareUrl))getResult {
    NSMutableDictionary *paraDic = [IBXHelpers getSignIBestRequestWithSession];
    [paraDic setValue:newID forKey:@"newsId"];
    [paraDic setValue:newType forKey:@"type"];
    [self qnPostPath:@"shareInfo" parameters:[self requestJsonDicWithParams:paraDic] showErrorInView:view needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *data = [IBXHelpers getStringWithDictionary:responseObject andForKey:@"data"];
        if (data.length) {
            getResult(data);
        }else {
            getResult(@"");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        getResult(@"");
    }];
}






@end

