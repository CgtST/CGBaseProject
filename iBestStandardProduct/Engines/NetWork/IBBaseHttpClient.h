//
//  ibBaseHttpClient.h
//  ibEngine
//
//  Created by manny on 14-12-14.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager+AutoRetry.h>


/* 网络层
 * 负责封装发送网络请求
 * 解析响应结果
 */


@interface IBBaseHttpClient : AFHTTPSessionManager


@property (nonatomic, strong,readonly) id responseJSONObject; //原生的返回数据
@property (nonatomic, strong,readonly) id responseResultJSONObject; //原生的result返回数据

@property (nonatomic, assign) dispatch_queue_t clientQueue;

//@Deprecated 基类会自动为每个请求加上SessionId
- (NSMutableDictionary *)defaultParamsDicWithSessionID;

- (NSDictionary *)requestJsonDicWithParams:(NSDictionary *)dic;

- (NSDictionary *)request_FX_JsonDicWithParams:(NSDictionary *)dic;


- (void)postNotificationInOpearationMainQueueWithName:(NSString *)notifyName
                                               object:(id)object
                                             userInfo:(NSDictionary *)userInfo;
- (void)postNotificationInGCDMainQueueWithName:(NSString *)notifyname
                                        object:(id)object
                                      userInfo:(NSDictionary *)userInfo;
- (void)performBlockInMainThread:(dispatch_block_t)block;
- (void)performBlockInMainQueue:(dispatch_block_t)block;

/**
 * 普通HTTP POST网络请求
 * 当showError为YES时,若view不可见或者为nil则不显示错误信息.
 * ignorecode为一个数组，遇到数组里的code则不做处理，直接会返回错误码给调用者。
 */

- (void)ibPostPath :(NSString *)path
         parameters:(NSDictionary *)parameters
    showErrorInView:(UIView *)view
      needShowError:(BOOL)show
         ignoreCode:(NSArray *)code
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 * 外汇HTTP POST网络请求,默认三次重试.
 */
- (void)ibFXPostPath :(NSString *)path
           parameters:(NSDictionary *)parameters
      showErrorInView:(UIView *)view
        needShowError:(BOOL)show
           ignoreCode:(NSArray *)code
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



/**
 * 外汇HTTP_交易相关 POST网络请求,默认三次重试.
 */
- (void)ibFX_Trade_PostPath :(NSString *)path
           parameters:(NSDictionary *)parameters
      showErrorInView:(UIView *)view
        needShowError:(BOOL)show
           ignoreCode:(NSArray *)code
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;





/**
 * 交易-----专用的普通HTTP POST网络请求,三次重试.
 */
- (void)ibTradePostPath :(NSString *)path
              parameters:(NSDictionary *)parameters
         showErrorInView:(UIView *)view
           needShowError:(BOOL)show
              ignoreCode:(NSArray *)code
                 success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                 failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 * 交易-----下单, 购买相关的专用的普通HTTP POST网络请求,失败后不再重试.
 */
- (void)ibTradeOrderAboutPostPath :(NSString *)path
                        parameters:(NSDictionary *)parameters
                   showErrorInView:(UIView *)view
                     needShowError:(BOOL)show
                        ignoreCode:(NSArray *)code
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;







/**
 * 上传文件数据请求
 * 暂不支持自定义文件名,全部使用默认文件名上传
 */
- (void)ibUpload:(NSString *)path
      parameters:(NSDictionary *)parameters
      uploadData:(NSData *)data
 showErrorInView:(UIView *)view
   needShowError:(BOOL)show
      ignoreCode:(NSArray *)code
         success:(void (^)(NSURLSessionDataTask *, id))success
         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;



/*
 * 生成一个客户端请求的唯一ID,13位时间戳＋6位自增长ID拼接而成。
 *
 */
- (NSString *)getReqId;
/**
 * 退出指定网络请求方法的所有Task
 */
- (void)cancelAllHTTPOperationsWithPath:(NSString *)path;
/**
 * 退出当前实例的所有Task
 */
- (void)cancelAllHttpTask;


#pragma mark - 交易相关
-(NSMutableDictionary *)defaultIbestTradeParameters;
-(NSDictionary *)requestIbestJsonDicWithParams:(NSDictionary *)dic;

@end



