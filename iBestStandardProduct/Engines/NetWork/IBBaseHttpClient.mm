//
//  ibBaseHttpClient.m
//  ibEngine
//
//  Created by manny on 14-12-14.
//  Copyright (c) 2014年 Bacai. All rights reserved.
//
#import <AFHTTPRequestOperation.h>
#import "IBBaseHttpClient.h"
#import "IBRemindView.h"
#import "IBNetService.h"
#import "IBSecurityManager.h"
#import "IBAccount.h"
#import "IBUserData.h"



#define DEFAULT_UPLOAD_RETRY_TIMES 3
#define DEFAULT_NORMAL_RETRY_TIMES 3
//默认重试间隔2秒
#define DEFAULT_RETRY_INTERVAL 30

//private method
@interface IBBaseHttpClient()

/**
 * private
 * 解析网络请求返回数据
 */
-(void)resolveResponse:(NSURLSessionDataTask *)task
              response:(id)resp
           requestPath:(NSString *)path
     requestParameters:(NSDictionary *)parameters
      showErrorInView:(UIView *)view
         needShowError:(BOOL)show
            ignoreCode:(NSArray *)code
               successBlock:(void (^)(NSURLSessionDataTask *, id))success
               failureBlock:(void (^)(NSURLSessionDataTask *, NSError *))failure;
/**
 * private
 * 获取网络请求返回的result
 */
-(NSDictionary *) getResult:(id)resp;
/**
* private
 * 获取网络请求返回的code
 */
-(NSNumber *) getCode:(id)resp;
/**
 * private
 * 获取网络请求返回的message
 */
-(NSString *)getMessage:(id)resp;


@property (nonatomic, strong,readwrite) id responseJSONObject;  //原封的返回原数据
@property (nonatomic, strong,readwrite) id responseResultJSONObject;
/**
 * private
 * 发送默认网络错误通知
 */
-(void) postDefaultNetError:(UIView *)view errorMessage:(NSString *)message errorCode:(NSInteger )code;


/**
 * private
 * 通用的解析错误code方法
 * 当showError为YES时,若view不可见或者为nil则不显示错误信息.
 * ignorecode为一个数组，遇到数组里的code则不做处理，直接会返回错误码给调用者。
 */
-(NSError *) processErrorCode:(id)resp
                         path:(NSString *)reqPath
              showErrorInView:(UIView *)view
                needShowError:(BOOL)show
                   ignoreCode:(NSArray *)code;

/**
 * private
 * 退出数组里的所有task
 */
- (void)cancelTasksInArray:(NSArray *)tasksArray;
/**
 * private
 * 退出数组里指定pathde所有task
 */
- (void)cancelTasksInArrayWithPath:(NSArray *)tasksArray withPath:(NSString *)path;

@end

@implementation IBBaseHttpClient

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL: url];
    if (self)
    {
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [self.requestSerializer setStringEncoding:NSUTF8StringEncoding];
        [self.responseSerializer setStringEncoding:NSUTF8StringEncoding];
        //[self.requestSerializer setValue:@"" forHTTPHeaderField:@""];
        //30秒超时
        [self.requestSerializer setTimeoutInterval:30];
        //不再校验服务器证书公钥，因为使用了CA认证的证书后安全性基本得到保证。除非CA根证书被污染。
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
  
#if defined(BUILD_TEST)
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [self.securityPolicy setValidatesDomainName:NO];
        self.securityPolicy.allowInvalidCertificates = YES;
#endif
        NSLog(@"%@: %@", NSStringFromClass([self class]), self.baseURL.absoluteString);
    }
    return self;
}

/**
 * 上传文件数据请求
 * 暂不支持自定义文件名,全部使用默认文件名上传
 */
/*- (void)ibUpload:(NSString *)path
      parameters:(NSDictionary *)parameters
      uploadData:(NSData *)data
 showErrorInView:(UIView *)view
   needShowError:(BOOL)show
      ignoreCode:(NSArray *)code
         success:(void (^)(NSURLSessionDataTask *, id))success
         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    @autoreleasepool
    {
        UIView __weak *weakView = view;//不加此行在做网络请求时候会造成Abandoned Memory.
        WEAKSELF
        NSDictionary *signParam = [sharedIBSecurityManager() signWithParamsForIB:parameters];
         NSLog(@"---------------------------打印的url地址：%@%@",self.baseURL.absoluteString,path);
        [self POST:path parameters:signParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //注意:这里使用默认name和文件全名
            [formData appendPartWithFileData:data name:@"default" fileName:@"default.jpg" mimeType:@"image/jpeg"];
        } success:^(NSURLSessionDataTask *task, id resp) {
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                success(task,resp);
                return;
            }
            [weakSelf resolveResponse:task response:resp requestPath:path requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"POST PATH : %@%@ \n Req: %@\n ERR: %@",self.baseURL.absoluteString, path, signParam, error);
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                failure(task,error);
                return;
            }
            switch (error.code) {
                //如果重试后还是出现-1003未找到指定主机名的服务则使用IP试一次
                case kCFURLErrorCannotFindHost:
                {
                    NSString *pathWithIp = [path stringByReplacingOccurrencesOfString:QN_BASE_DOMAIN withString:QN_IP_ADDRESS];
                    [weakSelf POST:pathWithIp parameters:signParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        [formData appendPartWithFileData:data name:@"default" fileName:@"default.jpg" mimeType:@"image/jpeg"];
                    } success:^(NSURLSessionDataTask *task, id resp) {
                        [self resolveResponse:task response:resp requestPath:pathWithIp requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
                    } failure: ^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"POST PATH with IP: %@ \n Req: %@\n ERR: %@", pathWithIp, signParam, error);
                        if (show) {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                        failure(task, error);
                    }];
                    break;
                }
                default:
                    if (show) {
                        if (NetService().networkStatus == NotReachable) {
                            [weakSelf postDefaultNetError:view errorMessage:CustomLocalizedString(@"QLIANJIESHIBAIQJCNDWLSZHI", nil) errorCode:error.code];
                        } else {
                            [weakSelf postDefaultNetError:view errorMessage:nil errorCode:error.code];
                        }
                    }
                    failure(task, error);
                    break;
            }
        } autoRetry:DEFAULT_UPLOAD_RETRY_TIMES retryInterval:DEFAULT_RETRY_INTERVAL];

    }
}*/



/**
 * 普通HTTP POST网络请求,默认三次重试.
 */
- (void)ibPostPath :(NSString *)path
         parameters:(NSDictionary *)parameters
    showErrorInView:(UIView *)view
      needShowError:(BOOL)show
         ignoreCode:(NSArray *)code
            success:(void (^)(NSURLSessionDataTask *, id))success
            failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    @autoreleasepool
    {
        UIView __weak *weakView = view;//不加此行在做网络请求时候会造成Abandoned Memory.
        WEAKSELF
        NSDictionary *signParam = [sharedIBSecurityManager() signWithParamsForIB:parameters]; //签名
        
        NSLog(@"POST url : %@%@ \n Req: %@\n", self.baseURL.absoluteString,path, signParam);
        [super POST:path parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                success(task,resp);
                return;
            }
            //处理返回结果
            [weakSelf resolveResponse:task response:resp requestPath:path requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
            
            
        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"POST PATH : %@ \n Req: %@\n ERR: %@", path, signParam, error);
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                failure(task,error);
                return;
            }
           
            if (show) {
                if (NetService().networkStatus == NotReachable) { //是网络原因
                    [weakSelf postDefaultNetError:weakView errorMessage:CustomLocalizedString(@"QLIANJIESHIBAIQJCNDWLSZHI", nil) errorCode:error.code];
                } else { //非网络原因
                    [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                }
            }
            failure(task, error);
            
        }autoRetry:DEFAULT_NORMAL_RETRY_TIMES retryInterval:DEFAULT_RETRY_INTERVAL];
    }
}





/**
 * 外汇HTTP POST网络请求,默认三次重试.
 */
/*- (void)ibFXPostPath :(NSString *)path
         parameters:(NSDictionary *)parameters
    showErrorInView:(UIView *)view
      needShowError:(BOOL)show
         ignoreCode:(NSArray *)code
            success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
            failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    @autoreleasepool
    {
        UIView __weak *weakView = view;//不加此行在做网络请求时候会造成Abandoned Memory.
        WEAKSELF
        NSDictionary *signParam = [sharedIBSecurityManager() signFXWithParamsForIB:parameters];

        NSLog(@"---------------------------打印的url地址：%@%@",self.baseURL.absoluteString,path);
        NSLog(@"POST PATH : %@ \n Req: %@\n", path, signParam);
        [super POST:path parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                success(task,resp);
                return;
            }
            [weakSelf resolveResponse:task response:resp requestPath:path requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"POST PATH : %@ \n Req: %@\n ERR: %@", path, signParam, error);
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                failure(task,error);
                return;
            }
            switch (error.code) {
                    //如果重试后还是出现-1003未找到指定主机名的服务则使用IP试一次
                case kCFURLErrorCannotFindHost:
                {
                    NSString *pathWithIp = [path stringByReplacingOccurrencesOfString:QN_BASE_DOMAIN withString:QN_IP_ADDRESS];
                    [super POST:pathWithIp parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
                        [weakSelf resolveResponse:task response:resp requestPath:pathWithIp requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
                    }failure: ^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"POST PATH with IP: %@ \n Req: %@\n ERR: %@", pathWithIp, signParam, error);
                        if (show) {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                        failure(task, error);
                    }];
                    break;
                }
                default:
                    if (show) {
                        if (NetService().networkStatus == NotReachable) {
                            [weakSelf postDefaultNetError:weakView errorMessage:CustomLocalizedString(@"QLIANJIESHIBAIQJCNDWLSZHI", nil) errorCode:error.code];
                        } else {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                    }
                    failure(task, error);
                    break;
            }
        }autoRetry:DEFAULT_NORMAL_RETRY_TIMES retryInterval:DEFAULT_RETRY_INTERVAL];
    }
}
*/




/**
 * 外汇HTTP_交易相关 POST网络请求,默认三次重试.
 */
- (void)ibFX_Trade_PostPath :(NSString *)path
                  parameters:(NSDictionary *)parameters
             showErrorInView:(UIView *)view
               needShowError:(BOOL)show
                  ignoreCode:(NSArray *)code
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    @autoreleasepool
    {
        NSString *sessionId = parameters[@"params"][@"sessionId"];
        UIView __weak *weakView = view;//不加此行在做网络请求时候会造成Abandoned Memory.
        WEAKSELF
        NSDictionary *signParam = [sharedIBSecurityManager() signFXWithParamsForIB:parameters];
        
        NSLog(@"---------------------------打印的url地址：%@%@",self.baseURL.absoluteString,path);
        NSLog(@"POST PATH : %@ \n Req: %@\n", path, signParam);
        [super POST:path parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
            [weakSelf handleInvalidCode:resp];   //对失效code的处理
            if (resp != nil) {
                success(task,resp);
                return;
            }
            
#pragma mark    交易相关接口禁止底层解析, 直接将结果进行返回
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                success(task,resp);
                return;
            }
            ///解析数据, 交易禁止辅助解析数据
            [weakSelf resolveResponse:task response:resp requestPath:path requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
            if ([weakSelf requestIsoverdueWith:parameters]) {
                failure(task,error);
                return;
            }
            switch (error.code) {
                //如果重试后还是出现-1003未找到指定主机名的服务则使用IP试一次
                case kCFURLErrorCannotFindHost:
                {
//                    NSString *pathWithIp = [path stringByReplacingOccurrencesOfString:QN_BASE_DOMAIN withString:QN_IP_ADDRESS];
//                    [super POST:pathWithIp parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
//                        [weakSelf resolveResponse:task response:resp requestPath:pathWithIp requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
//                    }failure: ^(NSURLSessionDataTask *task, NSError *error) {
//                        NSLog(@"POST PATH with IP: %@ \n Req: %@\n ERR: %@", pathWithIp, signParam, error);
//                        if (show) {
//                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
//                        }
//                        failure(task, error);
//                    }];
                    break;
                }
                default:
                    if (show) {
                        if (NetService().networkStatus == NotReachable) {
                            [weakSelf postDefaultNetError:weakView errorMessage:CustomLocalizedString(@"QLIANJIESHIBAIQJCNDWLSZHI", nil) errorCode:error.code];
                        } else {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                    }
                    failure(task, error);
                    break;
            }
        }autoRetry:0 retryInterval:DEFAULT_RETRY_INTERVAL];
    }
}






/**
 * 交易-----专用的普通HTTP POST网络请求,默认三次重试.
 */
/*- (void)ibTradePostPath :(NSString *)path
              parameters:(NSDictionary *)parameters
         showErrorInView:(UIView *)view
           needShowError:(BOOL)show
              ignoreCode:(NSArray *)code
                 success:(void (^)(NSURLSessionDataTask *, id))success
                 failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    @autoreleasepool
    {
        NSString *sessionId = parameters[@"params"][@"sessionId"];
        if([sessionId isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginHaveTimeOut object:nil];
            return;
        }
        
        UIView __weak *weakView = view;//不加此行在做网络请求时候会造成Abandoned Memory.
        WEAKSELF
        NSDictionary *signParam = [sharedIBSecurityManager() signTradeWithParamsForIB:parameters];
        
        NSLog(@"---------------------------打印的url地址：%@%@",self.baseURL.absoluteString,path);
        NSLog(@"POST PATH : %@ \n Req: %@\n", path, signParam);
//        [self extracted:code failure:failure parameters:parameters path:path show:show signParam:signParam success:success weakSelf:weakSelf weakView:weakView];
        [super POST:path parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
               [weakSelf handleInvalidCode:resp];   //对失效code的处理
            if (resp != nil) {
                success(task,resp);
                return;
            }
         
#pragma mark    交易相关接口禁止底层解析, 直接将结果进行返回
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                success(task,resp);
                return;
            }
            ///解析数据, 交易禁止辅助解析数据
            [weakSelf resolveResponse:task response:resp requestPath:path requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"POST PATH : %@ \n Req: %@\n ERR: %@", path, signParam, error);
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                failure(task,error);
                return;
            }
            switch (error.code) {
                    //如果重试后还是出现-1003未找到指定主机名的服务则使用IP试一次
                case kCFURLErrorCannotFindHost:
                {
                    NSString *pathWithIp = [path stringByReplacingOccurrencesOfString:QN_BASE_DOMAIN withString:QN_IP_ADDRESS];
                    [super POST:pathWithIp parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
                        [weakSelf resolveResponse:task response:resp requestPath:pathWithIp requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
                    }failure: ^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"POST PATH with IP: %@ \n Req: %@\n ERR: %@", pathWithIp, signParam, error);
                        if (show) {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                        failure(task, error);
                    }];
                    break;
                }
                default:
                    if (show) {
                        if (NetService().networkStatus == NotReachable) {
                            [weakSelf postDefaultNetError:weakView errorMessage:CustomLocalizedString(@"QLIANJIESHIBAIQJCNDWLSZHI", nil) errorCode:error.code];
                        } else {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                    }
                    failure(task, error);
                    break;
            }
        }autoRetry:0 retryInterval:DEFAULT_RETRY_INTERVAL];
    }
}*/



/**
 * 交易-----下单, 购买相关的专用的普通HTTP POST网络请求,失败后不再重试.
 */
/*- (void)ibTradeOrderAboutPostPath :(NSString *)path
                        parameters:(NSDictionary *)parameters
                   showErrorInView:(UIView *)view
                     needShowError:(BOOL)show
                        ignoreCode:(NSArray *)code
                           success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    @autoreleasepool
    {
        NSString *sessionId = parameters[@"params"][@"sessionId"];
        if([sessionId isEqualToString:@""]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginHaveTimeOut object:nil];
            return;
        }
        
        UIView __weak *weakView = view;//不加此行在做网络请求时候会造成Abandoned Memory.
        WEAKSELF
        NSDictionary *signParam = [sharedIBSecurityManager() signTradeWithParamsForIB:parameters];
        
        NSLog(@"---------------------------打印的url地址：%@%@",self.baseURL.absoluteString,path);
        NSLog(@"POST PATH : %@ \n Req: %@\n", path, signParam);
        [super POST:path parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
            
            [weakSelf handleInvalidCode:resp];
            if (resp != nil) {
                success(task,resp);
                return;
            }
#pragma mark    交易相关接口禁止底层解析, 直接将结果进行返回
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                success(task,resp);
                return;
            }
            [weakSelf resolveResponse:task response:resp requestPath:path requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
        } failure: ^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"POST PATH : %@ \n Req: %@\n ERR: %@", path, signParam, error);
            //当请求过期时不处理结果
            if ([weakSelf requestIsoverdueWith:parameters]) {
                failure(task,error);
                return;
            }
            switch (error.code) {
                    //如果重试后还是出现-1003未找到指定主机名的服务则使用IP试一次
                case kCFURLErrorCannotFindHost:
                {
                    NSString *pathWithIp = [path stringByReplacingOccurrencesOfString:QN_BASE_DOMAIN withString:QN_IP_ADDRESS];
                    [super POST:pathWithIp parameters:signParam success: ^(NSURLSessionDataTask *task, id resp) {
                        [weakSelf resolveResponse:task response:resp requestPath:pathWithIp requestParameters:signParam showErrorInView:weakView needShowError:show ignoreCode:code successBlock:success failureBlock:failure];
                    }failure: ^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"POST PATH with IP: %@ \n Req: %@\n ERR: %@", pathWithIp, signParam, error);
                        if (show) {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                        failure(task, error);
                    }];
                    break;
                }
                default:
                    if (show) {
                        if (NetService().networkStatus == NotReachable) {
                            [weakSelf postDefaultNetError:weakView errorMessage:CustomLocalizedString(@"QLIANJIESHIBAIQJCNDWLSZHI", nil) errorCode:error.code];
                        } else {
                            [weakSelf postDefaultNetError:weakView errorMessage:nil errorCode:error.code];
                        }
                    }
                    failure(task, error);
                    break;
            }
        }autoRetry:0 retryInterval:DEFAULT_RETRY_INTERVAL];
    }
}*/





#pragma mark - 对response 的处理

/**
 * 判断网络请求是否过期（比如切换了用户，或者重新登录了）
   NO  没有切换 ；Yes 切换了
 */
- (BOOL)requestIsoverdueWith:(NSDictionary *)parameters {
    NSString *requestSessionId = @"";
    //从网络请求参数中获取请求会话
    if (parameters[@"sessionId"]) {
        requestSessionId = parameters[@"sessionId"];
    }
    if (parameters[@"params"]) {
        NSDictionary *params = parameters[@"params"];
        if (params[@"sessionId"]) {
            requestSessionId = params[@"sessionId"];
        }
    }
    
    return ![sharedIBUserSystemManager().sessionID isEqualToString:requestSessionId];
}



/**
 处理response 返回结果
 */
-(void)resolveResponse:(NSURLSessionDataTask *)task
              response:(id)resp
           requestPath:(NSString *)path
     requestParameters:(NSDictionary *)parameters
       showErrorInView:(UIView *)view
         needShowError:(BOOL)show
            ignoreCode:(NSArray *)code
          successBlock:(void (^)(NSURLSessionDataTask *, id))success
          failureBlock:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *err = [NSError errorWithDomain: path
                                               code: ErrorCodeBadResponseData
                                           userInfo: nil];
            //当resp不是字典类型时返回错误.
            if (![resp isKindOfClass:[NSDictionary class]]) {
                if (show) {
                    [weakSelf postDefaultNetError:view errorMessage:nil errorCode:ErrorCodeBadResponseData];
                }
                failure(task,err);
                
            }
            NSNumber *respCode = [weakSelf getCode:resp];
            long int intCode = [respCode longValue];     //对session 失效的判断
           
            
            /*
            -1001.由于账户重新登录产生新session，旧session失效
            -1002.session超时
            -1003.禁用的session（3.1禁用用户时产生，3.2 其他原因xxxx）
            注:-1003,错误码备用，目前已用账户标识字段对用户登录进行限制
            */
            if(intCode == -1001 || intCode == -1002||intCode ==-1003 || intCode == -1004)
            {
                [IBGlobalMethod clearTradeUserDefaults];
                if (NetService().bGestValid == NO)
                {
                    User().bLogin = NO;
                    User().userType = IBUserTypeGuest;
                    User().isLevelTwo = @"0";
                    [weakSelf cancelAllHttpTask];
                    [NetService() logout];
                    NetService().bGestValid = YES;
                    [IBAccount currentAccount].session = INVALID_SESSION;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        BOOL bSessionLogin = NO;
                        if ([path isEqualToString: @"user_session_login"]) {
                            bSessionLogin = YES;
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionIdInvalid" object:nil]; //自选股用
                        NSString * message = @"";
                        if (intCode == -1001) {  //在另一设备上登录   如果在app启动登录的情况下

                        }else{
                            //游客登录
                            IBAccount *account = [IBAccount currentAccount];
                            if (![account.session isEqualToString: INVALID_SESSION]) {
                                account.session =  INVALID_SESSION;
                                [sharedIBUserSystemManager()  IBRegisterGuest:^(BOOL loginResult) {
                                    if (loginResult) {
                                        NSLog(@"游客登录成功");
                                        NetService().bGestValid = NO;
                                        if(bSessionLogin == YES){
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"IBSessionLoginInvalid" object:nil];
                                        }
                                    }else{
                                        NSLog(@"游客登录失败");
                                    }
                                } ];
                            }
                        }
                    });
                }

            }
            
            weakSelf.responseJSONObject = resp;
            NSDictionary *result = [weakSelf getResult:resp];
            weakSelf.responseResultJSONObject  = result;
            if (0 == [respCode integerValue])
            {
                success(task, result);
            }
            else
            {
                err = [weakSelf processErrorCode:resp path:path showErrorInView:view needShowError:show ignoreCode:code];
                failure(task, err);
            }

    });

}

/**
 处理错误信息
 @param view view description
 @param message message description
 @param code code description
 */
-(void) postDefaultNetError:(UIView *)view errorMessage:(NSString *)message errorCode:(NSInteger )code
{
    if((!view) || (!view.window) || [view isHidden]) {
        return;
    }
    
    NSString __block *blockMessage = message;
    dispatch_async(dispatch_get_main_queue(), ^{
        //当view不存在或者被隐藏时不显示错误提醒
        NSString *showMessage;
        if ((!blockMessage) || [blockMessage isEqualToString:@""]) {
            blockMessage = CustomLocalizedString(@"NETWORK_TIPS_CONTENT", nil);
            showMessage =  blockMessage;
        } else {
            showMessage = blockMessage;
        }
        //主动Cancel的错误不做提醒
        if (code == kCFURLErrorCancelled) {
            return;
        }
        [IBRemindView showMessag:showMessage toView:view];
    });
}



//返回错误Error
-(NSError *) processErrorCode:(id)resp
                         path:(NSString *)reqPath
              showErrorInView:(UIView *)view
                needShowError:(BOOL)show
                   ignoreCode:(NSArray *)code
{
    NSNumber *respCode = [self getCode:resp];
    NSDictionary *result = [self getResult:resp];
    NSString *message = [self getMessage:resp];
    
    
    //初始化默认userInfo,把服务器返回的所有结果code,message,result解析后存在userInfo里。
    NSMutableDictionary *userInfo = [NSMutableDictionary
                                     dictionaryWithDictionary:@{kHttpResponseCode : respCode,
                                                                kHttpResponseMessage : message,
                                                                kHttpResponseResult : result}];
    
    //调用者要求忽略的错误code直接丢回给调用者处理
    if ([code containsObject:respCode]) {
        return [NSError errorWithDomain: reqPath
                                   code: [respCode integerValue]
                               userInfo: userInfo];
    }
    switch ([respCode integerValue]) {
        case ErrorCodeSessionInvalid:
        case ErrorCodeErrGuestInsufficientPermissions:
            [self postNotificationInGCDMainQueueWithName: kQNCommonErrorFromServerNotify
                                                  object: self
                                                userInfo: userInfo];
            break;
            // 在对result结果解析时解析到updateInfo会提示用户升级
            // 所以此处不需做任何逻辑处理,但不能到default里弹错误提示.
        case ErrorCodeUpdateForce:
            break;
        default:
            if (show) {
                [self postDefaultNetError:view errorMessage:message errorCode:[respCode integerValue]];
                
            }
            break;
    }
    return [NSError errorWithDomain: reqPath
                               code: [respCode integerValue]
                           userInfo: userInfo];
}





-(NSDictionary *) getResult:(id)resp
{
    NSDictionary *result = [NSDictionary dictionary];
    
    //有key且key不为null时才赋值给result
    if (resp[@"result"] && ![resp[@"result"] isEqual:[NSNull null]]) {
        result = resp[@"result"];
    }
    //result不为字典类型时返回空字典
    if ([result isKindOfClass:[NSDictionary class]] && [result allKeys].count) {
        return result;
    }
    if ([resp isKindOfClass:[NSDictionary class]]) {
        return resp;
    }
    return @{};
}

-(NSDictionary *) getNewsResult:(id)resp
{
    NSDictionary *result = [NSDictionary dictionary];
    
    //有key且key不为null时才赋值给result
    if (resp[@"Data"] && ![resp[@"Data"] isEqual:[NSNull null]]) {
        result = resp[@"Data"];
    }
    //result不为字典类型时返回空字典
    if ([result isKindOfClass:[NSDictionary class]]) {
        return result;
    }
    if ([resp isKindOfClass:[NSDictionary class]]) {
        return resp;
    }
    return @{};
}

-(NSNumber *) getCode:(id)resp
{
    NSNumber *code = @(ErrorCodeEmptyResponseCode);
    //有key且key不为null时才赋值给code,否则返回ErrorCodeClientNetworkError
    if (resp[@"code"] && ![resp[@"code"] isEqual:[NSNull null]]) {
        code = resp[@"code"];
    }
    return code;
}

-(NSString *) getTradeMessage:(id) resp
{
    NSString *msg = @"";
    
    //有key且key不为null时才赋值给message,否则返回空字串
    if (resp[@"errorMsg"] && ![resp[@"errorMsg"] isEqual:[NSNull null]]) {
        msg = resp[@"errorMsg"];
    }
    
    return msg;

}

-(NSString *) getTradeErrorId:(id) resp
{
    NSString *msg = @"";
    
    //有key且key不为null时才赋值给message,否则返回空字串
    if (resp[@"errorId"] && ![resp[@"errorId"] isEqual:[NSNull null]]) {
        msg = resp[@"errorId"];
    }
    
    return msg;
    
}

-(BOOL) getNewsStatus:(id) resp
{
    BOOL newsStatus = NO;
    //有key且key不为null时才赋值给message,否则返回空字串
    if (resp[@"IsSuccess"] && ![resp[@"IsSuccess"] isEqual:[NSNull null]]) {
        newsStatus = [((NSNumber *)resp[@"IsSuccess"]) boolValue];
    }
    
    return newsStatus;
    
}

-(NSString *) getMessage:(id)resp
{
    NSString *msg = @"";
    //有key且key不为null时才赋值给message,否则返回空字串
    if (resp[@"message"] && ![resp[@"message"] isEqual:[NSNull null]]) {
        msg = resp[@"message"];
    }
    return msg;
}







- (NSMutableDictionary *)defaultParameters
{
    NSMutableDictionary *s_parms = nil;
    if (!s_parms) {
        s_parms = [NSMutableDictionary dictionary];
        s_parms[@"version"] = HTTP_PROTOCOL_VERSION;
        s_parms[@"id"] = [self getReqId];
        s_parms[@"osType"] = @(OSTypeiOS);
    }
    return [s_parms mutableCopy];
}

- (NSMutableDictionary *)defaultParamsDicWithSessionID
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"sessionId"] = sharedIBUserSystemManager().sessionID;
    
    return dic;
}

- (NSDictionary *)requestJsonDicWithParams:(NSDictionary *)dic
{
    NSMutableDictionary *parms = [self defaultParameters];
    parms[@"params"] = dic;
    //为每一个请求自动加上SessionID
    if (!dic[@"sessionId"]) {
        parms[@"params"][@"sessionId"] = sharedIBUserSystemManager().sessionID;
    }
    return parms;
}


//默认的http参数
- (NSDictionary *)request_FX_JsonDicWithParams:(NSDictionary *)dic {
    NSMutableDictionary *s_parms = [NSMutableDictionary dictionary];
    s_parms[@"version"] = HTTP_PROTOCOL_VERSION;
    s_parms[@"id"] = [self getReqId];
    s_parms[@"osType"] = @(OSTypeiOS);
    [s_parms setValue:sharedIBUserSystemManager().sessionID forKey:@"sessionId"];
    [s_parms setValue:dic forKey:@"params"];
    return s_parms;
}


#pragma mark - ibest
-(NSDictionary *)requestIbestJsonDicWithParams:(NSDictionary *)dic
{
    NSMutableDictionary *parms = [self defaultIbestTradeParameters];
    parms[@"params"] = [dic mutableCopy];
    //为每一个请求自动加上SessionID
    if (!dic[@"sessionId"]) {
        parms[@"params"][@"sessionId"] = sharedIBUserSystemManager().sessionID;
    }
    return parms;
}

-(NSMutableDictionary *)defaultIbestTradeParameters
{
    NSMutableDictionary *s_parms = nil;
//    if (!s_parms) {
//        s_parms = [NSMutableDictionary dictionary];
//        s_parms[@"version"] = HTTP_PROTOCOL_VERSION;
//         s_parms[@"osType"] = [@(OSTypeiOS) stringValue];
//        NSString *onlyID   = [IBXHelpers getOnlyGUID] ;
//        [s_parms setObject:onlyID forKey:@"ikey"];
//
//
//    }
    return [s_parms mutableCopy];
}



- (void)postNotificationInOpearationMainQueueWithName:(NSString *)notifyName
                                               object:(id)object
                                             userInfo:(NSDictionary *)userInfo
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: notifyName
                                                            object: object
                                                          userInfo: userInfo];
    }];
}
- (void)postNotificationInGCDMainQueueWithName:(NSString *)notifyname
                                        object:(id)object
                                      userInfo:(NSDictionary *)userInfo
{
    [self performBlockInMainThread:^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: notifyname
                                                            object: object
                                                          userInfo: userInfo];
    }];
}
- (void)performBlockInMainThread:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}
- (void)performBlockInMainQueue:(dispatch_block_t)block
{
    [[NSOperationQueue mainQueue] addOperationWithBlock: block];  
}

/*
 * 生成一个客户端请求的唯一ID,13位时间戳＋6位自增长ID拼接而成。
 * TODO:注意时区的转换，要求统一转换成UTC+8
 */
- (NSString *)getReqId {
    
    NSDate *currentDate = [NSDate date];
    //For Java timestamp.
    NSTimeInterval timeInterval = [currentDate timeIntervalSince1970]*1000;
    long long time = round(timeInterval);
    //增加6位自增长
    NSString *autoInc = [[[NSUserDefaults standardUserDefaults] objectForKey:@"IBTimeLockKey"] stringValue];
    if (!autoInc || [autoInc length] > 6) {
        autoInc = @"000000";
    }
    if ([autoInc length] < 6) {
        while ([autoInc length] < 6) {
            autoInc = [@"0" stringByAppendingString:autoInc];
        }
    }
    
    NSInteger autoIncInt = [autoInc integerValue];
    autoIncInt ++;
    [[NSUserDefaults standardUserDefaults] setObject:@(autoIncInt) forKey:@"IBTimeLockKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [NSString stringWithFormat:@"%lld%@",time,autoInc];
}

/**
 * 退出当前实例的所有Task
 */
- (void)cancelAllHttpTask
{
    WEAKSELF
    [[self session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        [weakSelf cancelTasksInArray:dataTasks];
        [weakSelf cancelTasksInArray:uploadTasks];
        [weakSelf cancelTasksInArray:downloadTasks];
    }];
}

/**
 * 退出指定网络请求方法的所有Task
 */
- (void)cancelAllHTTPOperationsWithPath:(NSString *)path
{
    WEAKSELF
    [[self session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        [weakSelf cancelTasksInArrayWithPath:dataTasks withPath:path];
        [weakSelf cancelTasksInArrayWithPath:uploadTasks withPath:path];
        [weakSelf cancelTasksInArrayWithPath:downloadTasks withPath:path];
    }];
}

- (void)cancelTasksInArray:(NSArray *)tasksArray
{
    for (NSURLSessionTask *task in tasksArray) {
        [task cancel];
    }
}
- (void)cancelTasksInArrayWithPath:(NSArray *)tasksArray withPath:(NSString *)path
{
    for (NSURLSessionTask *task in tasksArray) {
        NSRange range = [[[[task currentRequest]URL] absoluteString] rangeOfString:path];
        if (range.location != NSNotFound) {
            [task cancel];
        }
    }
}


//对失效的session的处理
-(void)handleInvalidCode:(id)resp
{
    if(![resp isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSNumber *respCode = [self getCode:resp];
    long int intCode = [respCode longValue];     //对session 失效的判断
    
    if(intCode == -1001 || intCode == -1002||intCode ==-1003 || intCode == -1004)
    {
    if (NetService().bGestValid == NO) {
      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionIdInvalid" object:nil]; //自选股用
        User().bLogin = NO;
        User().userType = IBUserTypeGuest;
        User().isLevelTwo = @"0";
        [self cancelAllHttpTask];
        NetService().bGestValid = YES;
        [NetService() logout];
        WEAKSELF
        dispatch_async(dispatch_get_main_queue(), ^{

            NSString * message = @"";
            if (intCode == -1001) {  //在另一设备上登录   如果在app启动登录的情况下
//                message =  [self getMessage:resp];
//                [IBAccount currentAccount].session = INVALID_SESSION;
//                [IBViewControllerHelp showSessionInvalidWithMessage:message errcode:intCode bSessionLogin:NO];
//                //不管成功或失败 返回到root
//                [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginCancled object:nil];
            }else{
                //游客登录
                IBAccount *account = [IBAccount currentAccount];
                if (![account.session isEqualToString:INVALID_SESSION]) {
                    account.session =  INVALID_SESSION;
                    [sharedIBUserSystemManager()  IBRegisterGuest:^(BOOL loginResult) {
                        if (loginResult) {
                            NSLog(@"游客登录成功");
                            NetService().bGestValid = NO;
                        }else{
                            NSLog(@"游客登录失败");
                        }
                        //不管成功或失败 返回到root
                        [[NSNotificationCenter defaultCenter] postNotificationName:TradeLoginCancled object:nil];

                    } ];
                }
            }
        });
    }
    }
}
@end
