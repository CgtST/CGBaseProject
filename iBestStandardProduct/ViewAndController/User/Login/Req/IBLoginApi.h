//
//  IBLoginApi.h
//  实际封装的登录请求类
//  Created by tj on 11/12/15.
//  Copyright © 2015 Bacai. All rights reserved.
//
#import "IBBaseHttpClient.h"
#import "IBLoginApi.h"

@class IBLoginParm;

//登录接口
@interface IBLoginApi : IBBaseHttpClient

//用户userID
@property (nonatomic, assign, readonly) int64_t userID;
@property (nonatomic, assign,readonly)  int32_t areaType;   //国家地区  1 中国内地，2香港

//会话ID
@property (nonatomic, assign, readonly) NSString *sessionId;

//用户信息
@property (nonatomic, strong, readonly) NSDictionary *userInfo;

//
@property (nonatomic, assign, readonly) int32_t userCode;

@property (nonatomic, strong, readonly) NSDictionary *quoteInfo;

- (id)initWithParm:(IBLoginParm *)loginParm;
/**
 游客登录
 
 @param block block description
 */
-(void)ibGestLoginResultBlock:(void(^)(id response,NSError * error))block;


@end
