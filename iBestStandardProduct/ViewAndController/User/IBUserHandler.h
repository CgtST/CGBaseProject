//
//  IBUserHandler.h
//  iBestStandard
//
//  Created by bingo on 2018/5/25.
//  Copyright © 2018年 iBest. All rights reserved.
//

#import "IBBaseHttpClient.h"

@interface IBUserHandler : IBBaseHttpClient


//session 自动登录
-(void)loginSessionWithDeviceInfo:(NSDictionary *) deviceInfo sessionId:(NSString *)sessionId                            resultBlock:(void (^) (id  responseObject, NSError *error))resultBlock;


@end
