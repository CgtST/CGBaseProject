//
//  IBHomeBtnLogoReq.m
//  iBestProduct
//
//  Created by zscftwo on 2017/12/18.
//  Copyright © 2017年 iBest. All rights reserved.
//

#import "IBHomeBtnLogoReq.h"

@implementation IBHomeBtnLogoReq


- (instancetype)init
{
    self = [super initWithBaseURL: QN_SSL_COMMON_BASE_URL];
    if (self) {

    }
    return self;
}



/**
 home 按钮图片

 @param resultBlock resultBlock description
 */
-(void)ibHomeBtnLogoReqWithResultBlock:(void (^) (id  responseObject, NSError *error))resultBlock
{
    NSMutableDictionary *params = [self defaultParamsDicWithSessionID];

//    [params setValue:[IBGlobalMethod getProjectVersion] forKey:@"version"];
    NSString *path = @"getHomepageIcons";
    NSDictionary *reqDic = [self requestJsonDicWithParams: params];


    WEAKSELF
    [self qnPostPath:path parameters:reqDic showErrorInView:nil needShowError:NO ignoreCode:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if(![responseObject isKindOfClass:[NSDictionary class]])
        {
            return ;
        }
        [weakSelf performBlockInMainThread:^{
            resultBlock(responseObject ,nil);
        }];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf performBlockInMainThread:^{
            resultBlock(nil ,error);
        }];
    }];
}

@end
